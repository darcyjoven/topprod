/*
================================================================================
檔案代號:ohe_file
檔案名稱:客诉原因代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ohe_file
(
ohe01       varchar2(20) NOT NULL,   /*客诉单号                               */
                                     /*客訴單號                               */
ohe02       number(5) NOT NULL,      /*行序                                   */
ohe03       varchar2(10),            /*原因代码                               */
                                     /*原因代碼                               */
ohe04       varchar2(1),             /*No Use                                 */
ohe05       varchar2(1)              /*No Use                                 */
);

alter table ohe_file add  constraint ohe_pk primary key  (ohe01,ohe02) enable validate;
grant select on ohe_file to tiptopgp;
grant update on ohe_file to tiptopgp;
grant delete on ohe_file to tiptopgp;
grant insert on ohe_file to tiptopgp;
grant index on ohe_file to public;
grant select on ohe_file to ods;
