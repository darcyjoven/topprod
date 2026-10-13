/*
================================================================================
檔案代號:gca_file
檔案名稱:文件资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gca_file
(
gca01       varchar2(80) NOT NULL,   /*第一组 Key 值                          */
gca02       varchar2(80) NOT NULL,   /*第二组 Key 值                          */
gca03       varchar2(80) NOT NULL,   /*第三组 Key 值                          */
gca04       varchar2(80) NOT NULL,   /*第四组 Key 值                          */
gca05       varchar2(80) NOT NULL,   /*第五组 Key 值                          */
gca06       number(10) NOT NULL,     /*序号                                   */
gca07       varchar2(30) NOT NULL,   /*文件编号                               */
gca08       varchar2(3) NOT NULL,    /*文件类型                               */
gca09       varchar2(10) NOT NULL,   /*文件分辑                               */
gca10       varchar2(3) NOT NULL,    /*文件版本                               */
gca11       varchar2(1),             /*文件有效否                             */
gca12       varchar2(10),            /*文件建立人员                           */
gca13       varchar2(10),            /*文件建立人员群组                       */
gca14       date,                    /*文件建立日期                           */
gca15       varchar2(10),            /*最后异动人员                           */
gca16       varchar2(10),            /*最后异动人员群组                       */
gca17       date                     /*最后异动日期                           */
);

create        index gca_02 on gca_file (gca07,gca08,gca09,gca10);
alter table gca_file add  constraint gca_pk primary key  (gca01,gca02,gca03,gca04,gca05,gca06) enable validate;
grant select on gca_file to tiptopgp;
grant update on gca_file to tiptopgp;
grant delete on gca_file to tiptopgp;
grant insert on gca_file to tiptopgp;
grant index on gca_file to public;
grant select on gca_file to ods;
