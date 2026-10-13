/*
================================================================================
檔案代號:imaslk_file
檔案名稱:SLK料件资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imaslk_file
(
imaslk00    varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
imaslk01    varchar2(1),             /*春                                     */
imaslk02    varchar2(1),             /*夏                                     */
imaslk03    varchar2(1),             /*秋                                     */
imaslk04    varchar2(1),             /*冬                                     */
imaslk05    number(5),               /*銷售年份                               */
imaslk06    number(5),               /*設計年份                               */
imaslk07    varchar2(1),             /*訂貨季                                 */
imaslk08    varchar2(1),             /*性别                                   */
imaslk09    date,                    /*上市日期                               */
imaslk10    varchar2(1),             /*上下裝                                 */
imaslk11    varchar2(10)             /*颜色                                   */
);

alter table imaslk_file add  constraint imaslk_pk primary key  (imaslk00) enable validate;
grant select on imaslk_file to tiptopgp;
grant update on imaslk_file to tiptopgp;
grant delete on imaslk_file to tiptopgp;
grant insert on imaslk_file to tiptopgp;
grant index on imaslk_file to public;
grant select on imaslk_file to ods;
