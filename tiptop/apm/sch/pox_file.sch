/*
================================================================================
檔案代號:pox_file
檔案名稱:多角贸易计价公式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pox_file
(
pox01       varchar2(8) NOT NULL,    /*流程代码                               */
                                     /*流程代碼                               */
pox02       date NOT NULL,           /*生效日期                               */
pox03       varchar2(1),             /*计价基准                               */
                                     /*計價基準                               */
                                     /*  1:依來源工廠                         */
                                     /*  2:依上層廠商                         */
pox04       number(5) NOT NULL,      /*站别                                   */
                                     /*站別                                   */
pox05       varchar2(1),             /*计算方式                               */
                                     /*Calculation Method                     */
                                     /*  1:Calculate by ratio                 */
                                     /*  2:According to formula A (Get the fixed price)*/
                                     /*  3:According to formula B (If the source value=0,*/
                                     /*    then get value 0,else get the fixed price)*/
pox06       number(9,4),             /*计价比率                               */
                                     /*計價比率(百分數) ex 0.06輸入6.00       */
pox07       varchar2(1),             /*No Use                                 */
pox08       varchar2(1),             /*No Use                                 */
pox09       varchar2(1),             /*No Use                                 */
pox10       varchar2(1)              /*No Use                                 */
);

alter table pox_file add  constraint pox_pk primary key  (pox01,pox02,pox04) enable validate;
grant select on pox_file to tiptopgp;
grant update on pox_file to tiptopgp;
grant delete on pox_file to tiptopgp;
grant insert on pox_file to tiptopgp;
grant index on pox_file to public;
grant select on pox_file to ods;
