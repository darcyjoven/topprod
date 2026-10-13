/*
================================================================================
檔案代號:lmm_file
檔案名稱:战盟基本数据单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmm_file
(
lmm01       varchar2(20) DEFAULT ' ' NOT NULL, /*战盟协议编号*/
lmm02       varchar2(10),            /*厂家编号                               */
lmm03       number(20),              /*门店数                                 */
lmm04       date,                    /*签订日期                               */
lmm05       varchar2(10),            /*终止人                                 */
lmm06       date,                    /*终止日期                               */
lmm07       varchar2(1),             /*是否签核                               */
lmm08       varchar2(1),             /*签核状态                               */
lmm09       varchar2(1),             /*确认码                                 */
lmm10       varchar2(10),            /*审核人                                 */
lmm11       date,                    /*审核日期                               */
lmm12       varchar2(50),            /*备注                                   */
lmmacti     varchar2(1),             /*资料有效码                             */
lmmcrat     date,                    /*资料创建日                             */
lmmdate     date,                    /*最近更改日                             */
lmmgrup     varchar2(10),            /*资料所有群                             */
lmmmodu     varchar2(10),            /*资料更改者                             */
lmmuser     varchar2(10),            /*资料所有者                             */
lmmoriu     varchar2(10),            /*资料建立者                             */
lmmorig     varchar2(10)             /*资料建立部门                           */
);

alter table lmm_file add  constraint lmm_pk primary key  (lmm01) enable validate;
grant select on lmm_file to tiptopgp;
grant update on lmm_file to tiptopgp;
grant delete on lmm_file to tiptopgp;
grant insert on lmm_file to tiptopgp;
grant index on lmm_file to public;
grant select on lmm_file to ods;
