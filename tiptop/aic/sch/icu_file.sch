/*
================================================================================
檔案代號:icu_file
檔案名稱:ICD料件制程资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icu_file
(
icu01       varchar2(40) NOT NULL,   /*母体料号                               */
icu02       varchar2(10) NOT NULL,   /*工艺编号                               */
icu03       varchar2(1),             /*Ccode否                                */
icu04       varchar2(5),             /*固定值(总code)                         */
icu05       varchar2(5),             /*前置 / 后置(总code)                    */
icu06       varchar2(5),             /*起始流水码(总Code)                     */
icu07       varchar2(5),             /*截止流水码(总Code)                     */
icu08       varchar2(5),             /*目前已用流水码(总Code)                 */
icu09       varchar2(5),             /*固定值(子code)                         */
icu10       varchar2(1),             /*前置 / 后置(子code)                    */
icu11       varchar2(5),             /*起始流水码(子Code)                     */
icu12       varchar2(5),             /*截止流水码(子Code)                     */
icu13       varchar2(5)              /*目前已用流水码(子Code)                 */
);

alter table icu_file add  constraint icu_pk primary key  (icu01,icu02) enable validate;
grant select on icu_file to tiptopgp;
grant update on icu_file to tiptopgp;
grant delete on icu_file to tiptopgp;
grant insert on icu_file to tiptopgp;
grant index on icu_file to public;
grant select on icu_file to ods;
