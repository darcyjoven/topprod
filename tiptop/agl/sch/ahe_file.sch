/*
================================================================================
檔案代號:ahe_file
檔案名稱:异动码类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahe_file
(
ahe01       varchar2(10) NOT NULL,   /*类型编号                               */
ahe02       varchar2(80),            /*核算项名称                             */
ahe03       varchar2(1),             /*资料来源                               */
                                     /*1.Common Data 2.Default Value 3.Manually Entered*/
ahe04       varchar2(15),            /*来源档案                               */
ahe05       varchar2(20),            /*来源编号字段                           */
ahe06       varchar2(20),            /*QRY编号                                */
                                     /*#FUN-5C0015 BY GILL                    */
ahe07       varchar2(20),            /*来源说明字段                           */
ahe08       number(5),               /*资料截取起始位数                       */
ahe09       number(5)                /*资料截取截止位数                       */
);

alter table ahe_file add  constraint ahe_pk primary key  (ahe01) enable validate;
grant select on ahe_file to tiptopgp;
grant update on ahe_file to tiptopgp;
grant delete on ahe_file to tiptopgp;
grant insert on ahe_file to tiptopgp;
grant index on ahe_file to public;
grant select on ahe_file to ods;
