/*
================================================================================
檔案代號:axf_file
檔案名稱:会计科目对冲关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axf_file
(
axf01       varchar2(24) NOT NULL,   /*母(子)公司科目编号                     */
axf02       varchar2(24) NOT NULL,   /*子公司科目编号                         */
axf03       varchar2(1),             /*比率否                                 */
axf04       varchar2(24),            /*借方差额科目编号                       */
axf05       varchar2(1),             /*No Use                                 */
axf06       varchar2(1),             /*No Use                                 */
axf07       varchar2(1),             /*No Use                                 */
axf08       varchar2(1),             /*No Use                                 */
axfacti     varchar2(1),             /*资料有效码                             */
axfuser     varchar2(10),            /*资料所有者                             */
axfgrup     varchar2(10),            /*资料所有部门                           */
axfmodu     varchar2(10),            /*资料更改者                             */
axfdate     date,                    /*最近更改日                             */
axf09       varchar2(10) NOT NULL,   /*来源：母(子)公司编号                   */
axf10       varchar2(10) NOT NULL,   /*对冲：子公司编号                       */
axf00       varchar2(5) NOT NULL,    /*母公司账套                             */
axf12       varchar2(5) NOT NULL,    /*子公司账套                             */
axf13       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
axf14       varchar2(1),             /*股本冲销                               */
axf15       varchar2(1) DEFAULT '1' NOT NULL, /*母(子)公司科目余额来源*/
axforig     varchar2(10),            /*资料建立部门                           */
axforiu     varchar2(10),            /*资料建立者                             */
axf16       varchar2(10) DEFAULT ' ' NOT NULL, /*合并主体*/
axf17       varchar2(1) DEFAULT '1' NOT NULL, /*子公司科目余额来源档案*/
axf18       varchar2(24),            /*贷方差额科目                           */
axf19       number(5)                /*冲销组别                               */
);

alter table axf_file add  constraint axf_pk primary key  (axf00,axf01,axf02,axf09,axf10,axf12,axf13,axf16) enable validate;
grant select on axf_file to tiptopgp;
grant update on axf_file to tiptopgp;
grant delete on axf_file to tiptopgp;
grant insert on axf_file to tiptopgp;
grant index on axf_file to public;
grant select on axf_file to ods;
