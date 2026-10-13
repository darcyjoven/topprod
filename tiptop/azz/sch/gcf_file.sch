/*
================================================================================
檔案代號:gcf_file
檔案名稱:V-Point Exporess 站台参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcf_file
(
gcf01       varchar2(10) NOT NULL,   /*TIPTOP 营运中心                        */
gcf02       varchar2(1) NOT NULL,    /*Express 站台设置                       */
gcf03       varchar2(15) NOT NULL,   /*Express 站台 IP 位置                   */
gcf04       varchar2(30) NOT NULL,   /*Express 站台名称                       */
gcf05       varchar2(1) NOT NULL,    /*Express 数据库                         */
gcf06       varchar2(10),            /*V-Point Express 站台数据库             */
gcf07       varchar2(10),            /*Express 站台 Port                      */
gcf08       varchar2(10),            /*No Use                                 */
gcf09       varchar2(1),             /*Express是否与BI集成                    */
gcf10       varchar2(1)              /*Express 站台是否为 V-Point4 Express    */
);

alter table gcf_file add  constraint gcf_pk primary key  (gcf01,gcf02,gcf03,gcf04,gcf05) enable validate;
grant select on gcf_file to tiptopgp;
grant update on gcf_file to tiptopgp;
grant delete on gcf_file to tiptopgp;
grant insert on gcf_file to tiptopgp;
grant index on gcf_file to public;
grant select on gcf_file to ods;
