/*
================================================================================
檔案代號:wcb_file
檔案名稱:spc 集成设置档(单头档设置)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wcb_file
(
wcb01       varchar2(20) NOT NULL,   /*程序编号                               */
wcb02       varchar2(15) NOT NULL,   /*程序使用单头档                         */
wcb03       varchar2(20) NOT NULL,   /*单头档 key 值字段1                     */
wcb04       varchar2(20),            /*单头档 key 值字段2                     */
wcb05       varchar2(20),            /*单头档 key 值字段3                     */
wcb06       varchar2(20),            /*单头档 key 值字段4                     */
wcb07       varchar2(20),            /*单头档 key 值字段5                     */
wcb08       varchar2(20),            /*单头档审核码字段                       */
wcb09       varchar2(20),            /*单头档spc抛转码字段                    */
wcb10       varchar2(1),             /*No Use                                 */
wcb11       varchar2(1),             /*No Use                                 */
wcb12       varchar2(1),             /*No Use                                 */
wcb13       varchar2(1),             /*No Use                                 */
wcb14       varchar2(1)              /*No Use                                 */
);

alter table wcb_file add  constraint wcb_pk primary key  (wcb01) enable validate;
grant select on wcb_file to tiptopgp;
grant update on wcb_file to tiptopgp;
grant delete on wcb_file to tiptopgp;
grant insert on wcb_file to tiptopgp;
grant index on wcb_file to public;
grant select on wcb_file to ods;
