/*
================================================================================
檔案代號:zod_file
檔案名稱:开账资料汇入记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table zod_file
(
zod00       varchar2(10) NOT NULL,   /*资料代码                               */
zod01       varchar2(15) NOT NULL,   /*档案代码                               */
zod02       varchar2(30) NOT NULL,   /*汇入序号                               */
zod03       varchar2(30),            /*汇入档名                               */
zod04       date,                    /*汇入日期                               */
zod05       varchar2(10),            /*汇入者                                 */
zod06       number(10),              /*汇入笔数                               */
zod07       varchar2(30),            /*旧单号(起)                             */
zod08       varchar2(30),            /*旧单号(讫)                             */
zod09       varchar2(30),            /*tp单号(起)                             */
zod10       varchar2(30),            /*tp单号(止)                             */
zod11       varchar2(1),             /*已删除否                               */
zod12       varchar2(1)
);

alter table zod_file add  constraint zod_pk primary key  (zod00,zod01,zod02) enable validate;
grant select on zod_file to tiptopgp;
grant update on zod_file to tiptopgp;
grant delete on zod_file to tiptopgp;
grant insert on zod_file to tiptopgp;
grant index on zod_file to public;
grant select on zod_file to ods;
