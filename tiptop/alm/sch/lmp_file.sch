/*
================================================================================
檔案代號:lmp_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmp_file
(
lmp00       varchar2(10),            /*No Use                                 */
lmp01       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lmp02       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lmp03       varchar2(4) DEFAULT ' ' NOT NULL, /*No Use*/
lmp04       varchar2(2) DEFAULT ' ' NOT NULL, /*No Use*/
lmp05       varchar2(10),            /*No Use                                 */
lmp06       varchar2(20),            /*No Use                                 */
lmp07       varchar2(10),            /*No Use                                 */
lmp08       number(20,2),            /*No Use                                 */
lmp09       number(20,2),            /*No Use                                 */
lmp10       date,                    /*No Use                                 */
lmp11       varchar2(10),            /*No Use                                 */
lmplegal    varchar2(10) NOT NULL,   /*No Use                                 */
lmpstore    varchar2(10) DEFAULT ' ' NOT NULL /*No Use*/
);

alter table lmp_file add  constraint lmp_pk primary key  (lmp01,lmp02,lmp03,lmp04) enable validate;
grant select on lmp_file to tiptopgp;
grant update on lmp_file to tiptopgp;
grant delete on lmp_file to tiptopgp;
grant insert on lmp_file to tiptopgp;
grant index on lmp_file to public;
grant select on lmp_file to ods;
