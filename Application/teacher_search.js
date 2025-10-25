$(document).ready(function () {
            // Ensure the table is empty on load
            $('#ipi-table tbody').empty();
            const searchInput = $("#teacher-search");
            const resultsDiv = $("#search-results");

            // helper: fetch sections for selected major+category and render checkboxes
            // Function to calculate and update the total number of students
            function updateTotalStudents() {
                let total = 0;
                // Iterate through checked checkboxes and sum their TOTAL_STUDENTS values
                $('#sections-container input[type=checkbox]:checked').each(function () {
                    const totalStudents = parseInt($(this).data('total-students')) || 0;
                    total += totalStudents;
                });
                // Update the total-students span
            $('#total-students').text(total);
            updateStudentCounts(); // Update presentee/absentee display
        }

            // Modified fetchSections function
            function fetchSections() {
                console.log('fetchSections triggered'); // Log function trigger

                const $majorSearch = $('#major-search');
                const $categorySearch = $('#category-search');

                const majorId = $majorSearch.data('selected-id') != null ? $majorSearch.data('selected-id').toString() : null;
                const categoryId = $categorySearch.data('selected-id') != null ? $categorySearch.data('selected-id').toString() : null;

                const $container = $('#sections-container');
                $container.empty();

                if (!majorId || !categoryId) {
                    console.warn(`fetchSections aborted: Missing ${!majorId ? 'majorId' : 'categoryId'}`);
                    return;
                }

                $.ajax({
                    url: 'teacher_sections.php',
                    method: 'GET',
                    data: { major: majorId, category: categoryId },
                    dataType: 'json',
                    beforeSend: function(){
                        $container.append('<div class="col-12 text-muted p-2">Loading sections...</div>');
                    },
                    success: function(response) {
                        console.log('teacher_sections response:', response);
                        if (response.message) {
                            $container.append(`<div class="col-12 text-center p-3 alert alert-info">${response.message}</div>`);
                            return;
                        }
                        if (!response || response.length === 0) {
                            $container.append('<div class="col-12 text-center p-3 alert alert-info">No session is available!</div>');
                            return;
                        }

                        // create checkbox for each section with total students
                        response.forEach(function(sec){
                            const sid = sec.SECTION_ID || '';
                            const sName = (sec.SECTION_NAME || '').trim();
                            const totalStudents = sec.TOTAL_STUDENTS || 0;
                            const $col = $('<div>').addClass('col-12 col-sm-6 col-md-4 text-start mb-2');
                            const checkboxId = 'checkbox-section-' + sid;
                            const $input = $('<input>')
                                .attr({ type: 'checkbox', id: checkboxId, name: 'sections[]', value: sid })
                                .addClass('css-checkbox')
                                .data('total-students', totalStudents) // Store total students as data attribute
                                .on('change', updateTotalStudents); // Attach event listener
                            const $label = $('<label>')
                                .attr('for', checkboxId)
                                .addClass('css-label lite-green-check')
                                .text(`${sName} (Total: ${totalStudents})`);
                            $col.append($input).append($label);
                            $container.append($col);
                        });

                        // Update total students after loading sections
                        updateTotalStudents();
                    },
                    error: function() {
                        $container.append('<div class="col-12 text-danger p-2">Error fetching sections</div>');
                    }
                });
            }

            searchInput.on("keyup", function () {
                const query = $(this).val().trim();

                if (query.length === 0) {
                    resultsDiv.hide().empty();
                    return;
                }

                $.ajax({
                    url: "teacher_search.php",
                    method: "GET",
                    data: { q: query },
                    dataType: "json",
                    success: function (data) {
                        let resultsContainer = $("#search-results");
                        resultsContainer.empty();

                        if (data.length === 0) {
                            resultsContainer.append('<div class="p-2 text-muted">No teachers found</div>');
                        } else {
                            data.forEach((teacher) => {
                                // build the result element using text() to avoid accidental leading/trailing whitespace
                                const first = teacher.TEACHER_FIRST_NAME == null ? '' : teacher.TEACHER_FIRST_NAME;
                                const last = teacher.TEACHER_LAST_NAME == null ? '' : teacher.TEACHER_LAST_NAME;
                                const name = (first + ' ' + last).trim();
                                const serial = teacher.TEACHER_SERIAL_NUMBER == null ? '' : teacher.TEACHER_SERIAL_NUMBER;
                                const $item = $("<div>")
                                    .addClass("p-2 result-item")
                                    .attr('data-serial', serial)
                                    .css({ cursor: "pointer", "border-bottom": "1px solid #eee" })
                                    .text(name);
                                resultsContainer.append($item);
                            });
                                }

                                resultsContainer.show();

                                // when clicking a result, fill the teacher input and load majors for that teacher
                                resultsContainer.find(".result-item").on("click", function () {
                                    const $this = $(this);
                                    const teacherName = $this.text();
                                    const teacherSerial = $this.attr('data-serial');

                                    console.log('Teacher selected:', teacherName, 'Serial:', teacherSerial); // Debug log

                                    // fill teacher input
                                    $("#teacher-search").val(teacherName);
                                    resultsContainer.hide();

                                    // fetch majors for this teacher and populate major-search-results
                                    if (teacherSerial) {
                                        console.log('Fetching majors for serial:', teacherSerial); // Debug log
                                        $.ajax({
                                            url: 'teacher_majors.php',
                                            method: 'GET',
                                            data: { serial: teacherSerial },
                                            dataType: 'json',
                                            success: function(majors){
                                                const $majContainer = $('#major-search-results');
                                                $majContainer.empty();
                                                if (!majors || majors.length === 0) {
                                                    $majContainer.append('<div class="p-2 text-muted">No majors found</div>');
                                                } else {
                                                    majors.forEach(function(m){
                                                        const mName = m.MAJOR_NAME == null ? '' : m.MAJOR_NAME.trim();
                                                        const mId = m.MAJOR_ID == null ? '' : m.MAJOR_ID;
                                                        const $mItem = $('<div>')
                                                            .addClass('p-2 major-result-item')
                                                            .attr('data-id', mId)
                                                            .css({ cursor: 'pointer', 'border-bottom': '1px solid #eee' })
                                                            .text(mName);
                                                        $majContainer.append($mItem);
                                                    });
                                                }
                                                $majContainer.show();

                                                // attach click handler for majors
                                                $majContainer.find('.major-result-item').on('click', function(){
                                                    const $m = $(this);
                                                    const name = $m.text();
                                                    const id = $m.attr('data-id');
                                                    console.log('Major clicked - name:', name, 'id:', id, 'type:', typeof id);
                                                    
                                                    const $majorSearch = $('#major-search');
                                                    
                                                    // Store the ID first (both as data and attribute)
                                                    $majorSearch
                                                        .data('selected-id', id)
                                                        .attr('data-selected-id', id)
                                                        .val(name);
                                                        
                                                    console.log('After setting major:', {
                                                        value: $majorSearch.val(),
                                                        dataId: $majorSearch.data('selected-id'),
                                                        attrId: $majorSearch.attr('data-selected-id'),
                                                        type: typeof $majorSearch.data('selected-id')
                                                    });
                                                    
                                                    $majContainer.hide();
                                                    // try to fetch sections if category already selected
                                                    fetchSections();
                                                });
                                            },
                                            error: function(){
                                                $('#major-search-results').html('<div class="p-2 text-danger">Error fetching majors</div>').show();
                                            }
                                        });
                                        console.log('Fetching categories for serial:', teacherSerial); // Debug log
                                        // fetch categories for this teacher and populate category-search-results
                                        $.ajax({
                                            url: 'teacher_categories.php',
                                            method: 'GET',
                                            data: { serial: teacherSerial },
                                            dataType: 'json',
                                            success: function(cats){
                                                const $catContainer = $('#category-search-results');
                                                $catContainer.empty();
                                                if (!cats || cats.length === 0) {
                                                    $catContainer.append('<div class="p-2 text-muted">No categories found</div>');
                                                } else {
                                                    cats.forEach(function(c){
                                                        console.log('Processing category:', c); // Debug log
                                                        const cName = (c.CATEGORY_NAME || '').trim();
                                                        // Fix: Use explicit check for undefined/null to handle 0 correctly
                                                        const cId = c.CATEGORY_ID != null ? c.CATEGORY_ID.toString() : '';
                                                        console.log('Category data - name:', cName, 'id:', cId); // Debug log
                                                        const $cItem = $('<div>')
                                                            .addClass('p-2 category-result-item')
                                                            .attr('data-id', cId)
                                                            .css({ cursor: 'pointer', 'border-bottom': '1px solid #eee' })
                                                            .text(cName);
                                                        console.log('Created category item with data-id:', $cItem.attr('data-id')); // Debug log
                                                        $catContainer.append($cItem);
                                                    });
                                                }
                                                $catContainer.show();

                                                // attach click handler for categories
                                                $catContainer.find('.category-result-item').on('click', function(){
                                                    const $c = $(this);
                                                    const name = $c.text();
                                                    const id = $c.attr('data-id');
                                                    console.log('Category selected - name:', name, 'id:', id);
                                                    const $categorySearch = $('#category-search');
                                                    
                                                    // Important: Store the id first before any other operations
                                                    $categorySearch.data('selected-id', id);
                                                    $categorySearch.val(name);
                                                    
                                                    console.log('After setting category:', {
                                                        value: $categorySearch.val(),
                                                        storedId: $categorySearch.data('selected-id'),
                                                        element: $categorySearch[0]
                                                    });
                                                    
                                                    $catContainer.hide();
                                                    
                                                    // Add a small delay to ensure data is set before fetching
                                                    setTimeout(fetchSections, 0);
                                                });
                                            },
                                            error: function(){
                                                $('#category-search-results').html('<div class="p-2 text-danger">Error fetching categories</div>').show();
                                            }
                                        });
                                    } else {
                                        console.warn('No teacher serial found, skipping major and category fetch'); // Debug log
                                    }
                                });
                    },
                    error: function () {
                        $("#search-results")
                            .html('<div class="p-2 text-danger">Error fetching data</div>')
                            .show();
                    },
                });
            });

            // Debug event handlers for major and category selection
            $('#major-search').on('change', function () {
                console.log('Major input value:', $(this).val());
                console.log('Major data-selected-id before:', $(this).data('selected-id'));
                fetchSections();
                console.log('Major data-selected-id after:', $(this).data('selected-id'));
            });

            $('#category-search').on('change', function () {
                console.log('Category input value:', $(this).val());
                console.log('Category data-selected-id before:', $(this).data('selected-id'));
                fetchSections();
                console.log('Category data-selected-id after:', $(this).data('selected-id'));
            });

        // Function to calculate and update student counts (present vs absent)
        function updateStudentCounts() {
            const $table = $('#ipi-table');
            const $tbodies = $table.find('tbody');
            console.log('Number of tbody elements:', $tbodies.length); // Debug log
            $tbodies.each((index, tbody) => {
                const $tbody = $(tbody);
                const rowCount = $tbody.find('tr').length;
                console.log(`tbody ${index} row count:`, rowCount); // Debug log
            });
            const totalStudents = parseInt($('#total-students').text(), 10) || 0;
            // Correctly count absentees by the number of rows in the table body
            const absenteeCount = $tbodies.first().find('tr').length; // Only count rows in the first tbody
            const presenteeCount = totalStudents - absenteeCount;

            $('#absentees-count').text(absenteeCount); // Update the count display
            $('#presentees-count').val(presenteeCount);
            $('#absentees-display').text(absenteeCount);
        }

        // Helper function to check if a student is already in the absentees table
        function isStudentAlreadyAdded(firstName, lastName) {
            const $existingRows = $('#ipi-table tbody tr');
            let isDuplicate = false;
            
            $existingRows.each(function() {
                const existingFirstName = $(this).find('.student-search-input').val().trim();
                const existingLastName = $(this).find('.student-last-name').text().trim();
                
                if (existingFirstName === firstName && existingLastName === lastName) {
                    isDuplicate = true;
                    return false; // Break the loop
                }
            });
            
            return isDuplicate;
        }

        // Function to add a new row to the Absentees table
        function addAbsenteeRow() {
            const totalStudents = parseInt($('#total-students').text(), 10);
            const absenteeCount = $('#ipi-table tbody tr').length;

            if (absenteeCount >= totalStudents) {
                alert("The number of absentees cannot exceed the total number of students.");
                return;
            }
            const $tableBody = $('#ipi-table tbody').first(); // Target the first tbody
            const uniqueId = Date.now(); // Add a unique identifier for debugging
            const newRowHtml = `
                <tr data-id="${uniqueId}">
                    <td style="position: relative;">
                        <input type="text" class="form-control student-search-input" placeholder="Enter First Name">
                        <div class="student-search-results-absentee" style="display: none; position: absolute; background-color: white; border: 1px solid #ccc; z-index: 1000; width: 100%;"></div>
                    </td>
                    <td class="student-last-name"></td>
                    <td><input type="text" class="form-control" placeholder="Enter Motif"></td>
                    <td><input type="text" class="form-control" placeholder="Enter Observation"></td>
                    <td class="text-center align-middle" style="max-height: 60px; height: 60px">
                        <a class="btn btnMaterial btn-flat primary semicircle" role="button" href="#"><i class="far fa-eye"></i></a>
                        <a class="btn btnMaterial btn-flat success semicircle" role="button" href="#"><i class="fas fa-pen"></i></a>
                        <a class="btn btnMaterial btn-flat accent btnNoBorders checkboxHover" role="button" data-bs-target="#delete-modal" data-bs-toggle="modal" href="#" style="margin-left: 5px">
                            <i class="fas fa-trash btnNoBorders" style="color: #dc3545"></i>
                        </a>
                    </td>
                </tr>
            `;

            console.log("Before appending, row count:", $tableBody.find('tr').length); // Debug log
            $tableBody.append(newRowHtml);
            console.log("After appending, row count:", $tableBody.find('tr').length); // Debug log
            updateStudentCounts();
        }

        // Use .off() to remove any existing handlers before attaching a new one
        // Ensure no duplicate event handlers for the Add Absentees button
        // ...
        // Debug log to confirm event handler attachment
        console.log("Attaching event handler to #add-absentee-btn");
        
        $(document).off('click', '#add-absentee-btn').on('click', '#add-absentee-btn', function () {
            console.log("addAbsenteeRow function triggered"); // Debug log to confirm function trigger
            addAbsenteeRow();
        });
        
        // Initial count update on page load
        updateStudentCounts();

        // Event delegation for student search in absentee table
        $('#ipi-table tbody').on('keyup', '.student-search-input', function() {
            const $input = $(this);
            const query = $input.val().trim();
            const $resultsContainer = $input.next('.student-search-results-absentee');
            
            const sections = $("input[name='sections[]']:checked").map(function () {
                return $(this).val();
            }).get();

            if (query.length === 0 || sections.length === 0) {
                $resultsContainer.hide().empty();
                return;
            }

            $.ajax({
                url: "student_search.php",
                method: "GET",
                data: { q: query, sections: sections },
                dataType: "json",
                success: function (data) {
                    $resultsContainer.empty();

                    if (data.error || !data || data.length === 0) {
                        $resultsContainer.append('<div class="p-2 text-muted">No students found</div>');
                    } else {
                        data.slice(0, 5).forEach((student) => {
                            const firstName = student.STUDENT_FIRST_NAME || '';
                            const lastName = student.STUDENT_LAST_NAME || '';
                            const studentId = student.STUDENT_ID || '';
                            const $item = $("<div>")
                                .addClass("p-2 result-item")
                                .attr('data-id', studentId)
                                .attr('data-first-name', firstName)
                                .attr('data-last-name', lastName)
                                .css({ cursor: "pointer", "border-bottom": "1px solid #eee" })
                                .text(`${firstName} ${lastName}`);
                            $resultsContainer.append($item);
                        });
                    }

                    $resultsContainer.show();
                },
                error: function () {
                    $resultsContainer.html('<div class="p-2 text-danger">Error fetching data</div>').show();
                }
            });
        });

        // Event delegation for clicking a result in absentee table - UPDATED to check for duplicates
        $('#ipi-table tbody').on('click', '.student-search-results-absentee .result-item', function() {
            const $item = $(this);
            const firstName = $item.attr('data-first-name');
            const lastName = $item.attr('data-last-name');
            
            // Check if student is already added
            if (isStudentAlreadyAdded(firstName, lastName)) {
                alert("This student is already in the absentees table.");
                $item.parent().hide().empty();
                return;
            }
            
            const $row = $item.closest('tr');
            $row.find('.student-search-input').val(firstName);
            $row.find('.student-last-name').text(lastName);
            
            $item.parent().hide().empty();
        });

        // New student search logic with debug logs
        const studentSearchInput = $("#student-first-name"); // Assuming the input field has this ID
        const studentLastNameField = $("#student-last-name"); // Assuming the last name field has this ID
        const selectedSections = () => $("input[name='sections[]']:checked").map(function () {
            return $(this).val();
        }).get();

        studentSearchInput.on("keyup", function () {
            const query = $(this).val().trim();
            const sections = selectedSections();

            console.log("Student search triggered");
            console.log("Query:", query);
            console.log("Selected sections:", sections);

            if (query.length === 0 || sections.length === 0) {
                console.warn("Search aborted: Empty query or no sections selected");
                $("#student-search-results").hide().empty();
                return;
            }

            $.ajax({
                url: "student_search.php", // Endpoint for student search
                method: "GET",
                data: { q: query, sections: sections },
                dataType: "json",
                success: function (data) {
                    console.log("Search results received:", data);
                    const resultsContainer = $("#student-search-results");
                    resultsContainer.empty();

                    if (data.error || data.length === 0) {
                        console.warn("No students found");
                        resultsContainer.append('<div class="p-2 text-muted">No students found</div>');
                    } else {
                        data.forEach((student) => {
                            const firstName = student.STUDENT_FIRST_NAME || '';
                            const lastName = student.STUDENT_LAST_NAME || '';
                            const studentId = student.STUDENT_ID || '';
                            const $item = $("<div>")
                                .addClass("p-2 result-item")
                                .attr('data-id', studentId)
                                .attr('data-last-name', lastName)
                                .css({ cursor: "pointer", "border-bottom": "1px solid #eee" })
                                .text(firstName);
                            resultsContainer.append($item);
                        });
                    }

                    resultsContainer.show();

                    // When clicking a result, fill the first and last name fields
                    resultsContainer.find(".result-item").on("click", function () {
                        const $this = $(this);
                        const firstName = $this.text();
                        const lastName = $this.attr('data-last-name');

                        console.log("Student selected:", { firstName, lastName });

                        studentSearchInput.val(firstName);
                        studentLastNameField.val(lastName);
                        resultsContainer.hide();
                    });
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching data:", { xhr, status, error });
                    $("#student-search-results")
                        .html('<div class="p-2 text-danger">Error fetching data</div>')
                        .show();
                },
            });
        });
    });