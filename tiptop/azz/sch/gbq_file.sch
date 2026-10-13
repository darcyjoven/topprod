/*
================================================================================
檔案代號:gbq_file
檔案名稱:Process 资料档
檔案目的:纪录每一user上线的各项资讯
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbq_file
(
gbq01       number(10) NOT NULL,     /*PID                                    */
gbq02       varchar2(30) NOT NULL,   /*FGLSERVER                              */
gbq03       varchar2(10) NOT NULL,   /*用户                                   */
gbq04       varchar2(20),            /*运行程序代码                           */
gbq05       varchar2(10),            /*用户部门                               */
gbq06       number(5),               /*GUI代码                                */
gbq07       varchar2(20),            /*开始运行时间                           */
gbq08       varchar2(20),            /*运行结束时间                           */
gbq09       varchar2(1),             /*No Use                                 */
gbq10       varchar2(21),            /*营运中心编号                           */
gbq11       varchar2(15)             /*AP 主机 IP                             */
);

alter table gbq_file add  constraint gbq_pk primary key  (gbq01,gbq02,gbq03) enable validate;
grant select on gbq_file to tiptopgp;
grant update on gbq_file to tiptopgp;
grant delete on gbq_file to tiptopgp;
grant insert on gbq_file to tiptopgp;
grant index on gbq_file to public;
grant select on gbq_file to ods;
