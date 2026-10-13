/*
================================================================================
檔案代號:gim_file
檔案名稱:揭露事项说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gim_file
(
gim00       varchar2(1) NOT NULL,    /*合并否                                 */
                                     /*合併否(Y/N)                            */
gim01       number(5) NOT NULL,      /*顺序                                   */
                                     /*順序                                   */
gim02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
gim03       number(20,6),            /*金额                                   */
                                     /*金額                                   */
gim04       number(5) DEFAULT '0' NOT NULL, /*年度*/
gim05       number(5) DEFAULT '0' NOT NULL, /*期别*/
gim06       varchar2(10) DEFAULT ' ' NOT NULL /*族群编号*/
);

alter table gim_file add  constraint gim_pk primary key  (gim00,gim01,gim04,gim05,gim06) enable validate;
grant select on gim_file to tiptopgp;
grant update on gim_file to tiptopgp;
grant delete on gim_file to tiptopgp;
grant insert on gim_file to tiptopgp;
grant index on gim_file to public;
grant select on gim_file to ods;
