/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     10/14/2025 9:37:40 PM                        */
/*==============================================================*/

/*==============================================================*/
/* Table: ABSENCE                                               */
/*==============================================================*/
create table ABSENCE
(
   ABSENCE_ID           int not null  comment '',
   STUDY_SESSION_ID     int not null  comment '',
   ABSENCE_DATE_AND_TIME datetime  comment '',
   ABSENCE_MOTIF        varchar(30)  comment '',
   ABSENCE_OBSERVATION  varchar(258)  comment '',
   primary key (ABSENCE_ID)
);

/*==============================================================*/
/* Table: ADMINISTRATOR                                         */
/*==============================================================*/
create table ADMINISTRATOR
(
   ADMINISTRATOR_ID     int not null  comment '',
   USER_ID              int not null  comment '',
   ADMINISTRATOR_FIRST_NAME varchar(24)  comment '',
   ADMINISTRATOR_LAST_NAME varchar(24)  comment '',
   ADMINISTRATOR_POSITION varchar(24)  comment '',
   primary key (ADMINISTRATOR_ID)
);

/*==============================================================*/
/* Table: CATEGORY                                              */
/*==============================================================*/
create table CATEGORY
(
   CATEGORY_ID          int not null  comment '',
   CATEGORY_NAME        varchar(12)  comment '',
   primary key (CATEGORY_ID)
);

/*==============================================================*/
/* Table: CLASS                                                 */
/*==============================================================*/
create table CLASS
(
   CLASS_ID             int not null  comment '',
   USER_ID              int not null  comment '',
   CLASS_NAME           varchar(12)  comment '',
   primary key (CLASS_ID)
);

/*==============================================================*/
/* Table: MAJOR                                                 */
/*==============================================================*/
create table MAJOR
(
   MAJOR_ID             varchar(12) not null  comment '',
   MAJOR_NAME           varchar(48)  comment '',
   primary key (MAJOR_ID)
);

/*==============================================================*/
/* Table: NOTIFICATION                                          */
/*==============================================================*/
create table NOTIFICATION
(
   NOTIFICATION_ID      int not null  comment '',
   primary key (NOTIFICATION_ID)
);

/*==============================================================*/
/* Table: OBSERVATION                                           */
/*==============================================================*/
create table OBSERVATION
(
   OBSERVATION_ID       int not null  comment '',
   STUDY_SESSION_ID     int not null  comment '',
   primary key (OBSERVATION_ID)
);

/*==============================================================*/
/* Table: RECEIVES                                              */
/*==============================================================*/
create table RECEIVES
(
   NOTIFICATION_ID      int not null  comment '',
   ADMINISTRATOR_ID     int not null  comment '',
   primary key (NOTIFICATION_ID, ADMINISTRATOR_ID)
);

/*==============================================================*/
/* Table: SECTION                                               */
/*==============================================================*/
create table SECTION
(
   SECTION_ID           int not null  comment '',
   CATEGORY_ID          int not null  comment '',
   SECTION_NAME         varchar(30)  comment '',
   primary key (SECTION_ID)
);

/*==============================================================*/
/* Table: SENDS                                                 */
/*==============================================================*/
create table SENDS
(
   NOTIFICATION_ID      int not null  comment '',
   CLASS_ID             int not null  comment '',
   primary key (NOTIFICATION_ID, CLASS_ID)
);

/*==============================================================*/
/* Table: STUDENT                                               */
/*==============================================================*/
create table STUDENT
(
   STUDENT_SERIAL_NUMBER varchar(16) not null  comment '',
   CATEGORY_ID          int not null  comment '',
   SECTION_ID           int not null  comment '',
   STUDENT_FIRST_NAME   varchar(24)  comment '',
   STUDENT_LAST_NAME    varchar(24)  comment '',
   STUDNET_GRADE        varchar(24)  comment '',
   primary key (STUDENT_SERIAL_NUMBER)
);

/*==============================================================*/
/* Table: STUDENT_GETS_ABSENT                                   */
/*==============================================================*/
create table STUDENT_GETS_ABSENT
(
   STUDENT_SERIAL_NUMBER varchar(16) not null  comment '',
   ABSENCE_ID           int not null  comment '',
   primary key (STUDENT_SERIAL_NUMBER, ABSENCE_ID)
);

/*==============================================================*/
/* Table: STUDIES                                               */
/*==============================================================*/
create table STUDIES
(
   SECTION_ID           int not null  comment '',
   MAJOR_ID             varchar(12) not null  comment '',
   primary key (SECTION_ID, MAJOR_ID)
);

/*==============================================================*/
/* Table: STUDIES_IN                                            */
/*==============================================================*/
create table STUDIES_IN
(
   SECTION_ID           int not null  comment '',
   STUDY_SESSION_ID     int not null  comment '',
   primary key (SECTION_ID, STUDY_SESSION_ID)
);

/*==============================================================*/
/* Table: STUDY_SESSION                                         */
/*==============================================================*/
create table STUDY_SESSION
(
   STUDY_SESSION_ID     int not null  comment '',
   TEACHER_SERIAL_NUMBER varchar(16) not null  comment '',
   STUDY_SESSION_DATE   date  comment '',
   STUDY_SESSION_START_TIME time  comment '',
   STUDY_SESSION_END_TIME time  comment '',
   primary key (STUDY_SESSION_ID)
);

/*==============================================================*/
/* Table: TEACHER                                               */
/*==============================================================*/
create table TEACHER
(
   TEACHER_SERIAL_NUMBER varchar(16) not null  comment '',
   TEACHER_GRADE        varchar(24)  comment '',
   TEACHER_FIRST_NAME   varchar(24)  comment '',
   TEACHER_LAST_NAME    varchar(24)  comment '',
   primary key (TEACHER_SERIAL_NUMBER)
);

/*==============================================================*/
/* Table: TEACHER_GETS_ABSENT                                   */
/*==============================================================*/
create table TEACHER_GETS_ABSENT
(
   TEACHER_SERIAL_NUMBER varchar(16) not null  comment '',
   ABSENCE_ID           int not null  comment '',
   primary key (TEACHER_SERIAL_NUMBER, ABSENCE_ID)
);

/*==============================================================*/
/* Table: TEACHER_MAKES_AN_OBSERVATION_FOR_A_STUDENT            */
/*==============================================================*/
create table TEACHER_MAKES_AN_OBSERVATION_FOR_A_STUDENT
(
   STUDENT_SERIAL_NUMBER varchar(16) not null  comment '',
   OBSERVATION_ID       int not null  comment '',
   TEACHER_SERIAL_NUMBER varchar(16) not null  comment '',
   OBSERVATION_DATE_AND_TIME datetime  comment '',
   OBSERVATION_MOTIF    varchar(30)  comment '',
   OBSERVATION_NOTE     varchar(256)  comment '',
   primary key (STUDENT_SERIAL_NUMBER, OBSERVATION_ID, TEACHER_SERIAL_NUMBER)
);

/*==============================================================*/
/* Table: TEACHES                                               */
/*==============================================================*/
create table TEACHES
(
   MAJOR_ID             varchar(12) not null  comment '',
   TEACHER_SERIAL_NUMBER varchar(16) not null  comment '',
   primary key (MAJOR_ID, TEACHER_SERIAL_NUMBER)
);

/*==============================================================*/
/* Table: USER_ACCOUNT                                          */
/*==============================================================*/
create table USER_ACCOUNT
(
   USER_ID              int not null  comment '',
   USERNAME             varchar(30)  comment '',
   PASSWORD_HASH        varchar(1024)  comment '',
   EMAIL                varchar(60)  comment '',
   ROLE                 varchar(15)  comment '',
   ACCOUNT_STATUS       varchar(12)  comment '',
   CREATED_AT           datetime  comment '',
   LAST_LOGIN_AT        datetime  comment '',
   primary key (USER_ID)
);

alter table ABSENCE add constraint FK_ABSENCE_TAKES_PLA_STUDY_SE foreign key (STUDY_SESSION_ID)
      references STUDY_SESSION (STUDY_SESSION_ID) on delete restrict on update restrict;

alter table ADMINISTRATOR add constraint FK_ADMINIST_ADMINISTR_USER_ACC foreign key (USER_ID)
      references USER_ACCOUNT (USER_ID) on delete restrict on update restrict;

alter table CLASS add constraint FK_CLASS_CLASS_USE_USER_ACC foreign key (USER_ID)
      references USER_ACCOUNT (USER_ID) on delete restrict on update restrict;

alter table OBSERVATION add constraint FK_OBSERVAT_HAPPENS_I_STUDY_SE foreign key (STUDY_SESSION_ID)
      references STUDY_SESSION (STUDY_SESSION_ID) on delete restrict on update restrict;

alter table RECEIVES add constraint FK_RECEIVES_RECEIVES_ADMINIST foreign key (ADMINISTRATOR_ID)
      references ADMINISTRATOR (ADMINISTRATOR_ID) on delete restrict on update restrict;

alter table RECEIVES add constraint FK_RECEIVES_RECEIVES2_NOTIFICA foreign key (NOTIFICATION_ID)
      references NOTIFICATION (NOTIFICATION_ID) on delete restrict on update restrict;

alter table SECTION add constraint FK_SECTION_BELONGS_T_CATEGORY foreign key (CATEGORY_ID)
      references CATEGORY (CATEGORY_ID) on delete restrict on update restrict;

alter table SENDS add constraint FK_SENDS_SENDS_CLASS foreign key (CLASS_ID)
      references CLASS (CLASS_ID) on delete restrict on update restrict;

alter table SENDS add constraint FK_SENDS_SENDS2_NOTIFICA foreign key (NOTIFICATION_ID)
      references NOTIFICATION (NOTIFICATION_ID) on delete restrict on update restrict;

alter table STUDENT add constraint FK_STUDENT_BELONGS_T_SECTION foreign key (SECTION_ID)
      references SECTION (SECTION_ID) on delete restrict on update restrict;

alter table STUDENT add constraint FK_STUDENT_IS_OF_CAT_CATEGORY foreign key (CATEGORY_ID)
      references CATEGORY (CATEGORY_ID) on delete restrict on update restrict;

alter table STUDENT_GETS_ABSENT add constraint FK_STUDENT__STUDENT_G_ABSENCE foreign key (ABSENCE_ID)
      references ABSENCE (ABSENCE_ID) on delete restrict on update restrict;

alter table STUDENT_GETS_ABSENT add constraint FK_STUDENT__STUDENT_G_STUDENT foreign key (STUDENT_SERIAL_NUMBER)
      references STUDENT (STUDENT_SERIAL_NUMBER) on delete restrict on update restrict;

alter table STUDIES add constraint FK_STUDIES_STUDIES_MAJOR foreign key (MAJOR_ID)
      references MAJOR (MAJOR_ID) on delete restrict on update restrict;

alter table STUDIES add constraint FK_STUDIES_STUDIES2_SECTION foreign key (SECTION_ID)
      references SECTION (SECTION_ID) on delete restrict on update restrict;

alter table STUDIES_IN add constraint FK_STUDIES__STUDIES_I_STUDY_SE foreign key (STUDY_SESSION_ID)
      references STUDY_SESSION (STUDY_SESSION_ID) on delete restrict on update restrict;

alter table STUDIES_IN add constraint FK_STUDIES__STUDIES_I_SECTION foreign key (SECTION_ID)
      references SECTION (SECTION_ID) on delete restrict on update restrict;

alter table STUDY_SESSION add constraint FK_STUDY_SE_TEACHES_I_TEACHER foreign key (TEACHER_SERIAL_NUMBER)
      references TEACHER (TEACHER_SERIAL_NUMBER) on delete restrict on update restrict;

alter table TEACHER_GETS_ABSENT add constraint FK_TEACHER__TEACHER_G_ABSENCE foreign key (ABSENCE_ID)
      references ABSENCE (ABSENCE_ID) on delete restrict on update restrict;

alter table TEACHER_GETS_ABSENT add constraint FK_TEACHER__TEACHER_G_TEACHER foreign key (TEACHER_SERIAL_NUMBER)
      references TEACHER (TEACHER_SERIAL_NUMBER) on delete restrict on update restrict;

alter table TEACHER_MAKES_AN_OBSERVATION_FOR_A_STUDENT add constraint FK_TEACHER__TEACHER_M_TEACHER foreign key (TEACHER_SERIAL_NUMBER)
      references TEACHER (TEACHER_SERIAL_NUMBER) on delete restrict on update restrict;

alter table TEACHER_MAKES_AN_OBSERVATION_FOR_A_STUDENT add constraint FK_TEACHER__TEACHER_M_STUDENT foreign key (STUDENT_SERIAL_NUMBER)
      references STUDENT (STUDENT_SERIAL_NUMBER) on delete restrict on update restrict;

alter table TEACHER_MAKES_AN_OBSERVATION_FOR_A_STUDENT add constraint FK_TEACHER__TEACHER_M_OBSERVAT foreign key (OBSERVATION_ID)
      references OBSERVATION (OBSERVATION_ID) on delete restrict on update restrict;

alter table TEACHES add constraint FK_TEACHES_TEACHES_TEACHER foreign key (TEACHER_SERIAL_NUMBER)
      references TEACHER (TEACHER_SERIAL_NUMBER) on delete restrict on update restrict;

alter table TEACHES add constraint FK_TEACHES_TEACHES2_MAJOR foreign key (MAJOR_ID)
      references MAJOR (MAJOR_ID) on delete restrict on update restrict;

