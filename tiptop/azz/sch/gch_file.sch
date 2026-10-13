/*
================================================================================
檔案代號:gch_file
檔案名稱:V-Point Express 数据库详细设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gch_file
(
gch01       varchar2(10) NOT NULL,   /*TIPTOP 营运中心                        */
gch02       varchar2(1) NOT NULL,    /*Express 站台设置                       */
gch03       varchar2(15) NOT NULL,   /*Express 站台 IP 位置                   */
gch04       varchar2(10) NOT NULL,   /*Express 站台名称                       */
gch05       varchar2(1) NOT NULL,    /*Express 数据库                         */
gch06       varchar2(15) NOT NULL,   /*V-Point Express 站台数据库             */
gch07       varchar2(6) NOT NULL,    /*V-Point Express 数据库 IP              */
gch08       varchar2(10) NOT NULL,   /*V-Point Express 数据库 Port            */
gch09       varchar2(20) NOT NULL,   /*V-Point Express 数据库名称/SID         */
gch10       varchar2(20) NOT NULL,   /*V-Point Express 数据库口令             */
gch11       varchar2(255),           /*Express SOAP Services 连接网址         */
gch12       varchar2(20),            /*Express 系统帐号                       */
gch13       varchar2(20)             /*Express 系统口令                       */
);

alter table gch_file add  constraint gch_pk primary key  (gch01,gch02,gch03,gch04,gch05,gch06,gch07,gch08,gch09,gch10) enable validate;
grant select on gch_file to tiptopgp;
grant update on gch_file to tiptopgp;
grant delete on gch_file to tiptopgp;
grant insert on gch_file to tiptopgp;
grant index on gch_file to public;
grant select on gch_file to ods;
