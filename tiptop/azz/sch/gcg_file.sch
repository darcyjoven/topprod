/*
================================================================================
檔案代號:gcg_file
檔案名稱:V-Point Express 关联报表设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcg_file
(
gcg01       varchar2(10) NOT NULL,   /*TIPTOP 营运中心                        */
gcg02       varchar2(1) NOT NULL,    /*Express 站台设置                       */
gcg03       varchar2(15) NOT NULL,   /*Express 站台 IP 位置                   */
gcg04       varchar2(10) NOT NULL,   /*Express 站台名称                       */
gcg05       varchar2(1) NOT NULL,    /*Express 数据库                         */
gcg06       varchar2(20) NOT NULL,   /*程序编号                               */
gcg07       varchar2(128) NOT NULL,  /*关联报表名称                           */
gcg08       varchar2(255) NOT NULL,  /*报表 ID                                */
gcg09       varchar2(128),           /*关联报表名称                           */
gcg10       varchar2(255),           /*报表ID                                 */
gcg11       varchar2(5) NOT NULL,    /*报表类型                               */
gcg12       varchar2(10),            /*No Use                                 */
gcg13       varchar2(10)             /*No Use                                 */
);

alter table gcg_file add  constraint gcg_pk primary key  (gcg01,gcg02,gcg03,gcg04,gcg05,gcg06,gcg07,gcg11) enable validate;
grant select on gcg_file to tiptopgp;
grant update on gcg_file to tiptopgp;
grant delete on gcg_file to tiptopgp;
grant insert on gcg_file to tiptopgp;
grant index on gcg_file to public;
grant select on gcg_file to ods;
