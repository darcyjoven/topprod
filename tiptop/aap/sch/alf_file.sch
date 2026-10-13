/*
================================================================================
檔案代號:alf_file
檔案名稱:赎单对应预购单明细单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table alf_file
(
alf01       varchar2(20) NOT NULL,   /*赎单单号                               */
                                     /*贖單單號                               */
alf02       varchar2(20) NOT NULL,   /*预购单号                               */
                                     /*預購單號                               */
alf03       varchar2(1),             /*预购单分摊方式                         */
                                     /*預購單分攤方式                         */
                                     /*  1.按贖單到貨金額比率分攤             */
                                     /*  2.按指定比率分攤                     */
                                     /*  3.將預購單剩餘金額全部分攤至本次贖單 */
                                     /*  4.按指定金額分攤                     */
alf05       number(20,6),            /*该预购单到货金额                       */
                                     /*該預購單到貨金額                       */
alf06       number(9,4),             /*该预购单应摊比率                       */
                                     /*該預購單應攤比率(%)                    */
alf07       number(20,6),            /*该预购单应摊金额                       */
                                     /*該預購單應攤金額                       */
alflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index alf_02 on alf_file (alf02);
alter table alf_file add  constraint alf_pk primary key  (alf01,alf02) enable validate;
grant select on alf_file to tiptopgp;
grant update on alf_file to tiptopgp;
grant delete on alf_file to tiptopgp;
grant insert on alf_file to tiptopgp;
grant index on alf_file to public;
grant select on alf_file to ods;
