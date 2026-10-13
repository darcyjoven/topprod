/*
================================================================================
檔案代號:oct_file
檔案名稱:递延收入档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oct_file
(
oct00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
oct01       varchar2(20) DEFAULT ' ' NOT NULL, /*应收单号*/
oct02       number(5) DEFAULT '0' NOT NULL, /*应收单据项次*/
oct03       varchar2(40),            /*料件编号                               */
oct04       varchar2(20),            /*出货单号                               */
oct05       number(5),               /*出货单项次                             */
oct06       varchar2(20),            /*销退单号                               */
oct07       number(5),               /*销退单项次                             */
oct08       varchar2(20),            /*凭证编号                               */
oct09       number(5) DEFAULT '0' NOT NULL, /*递延年度*/
oct10       number(5) DEFAULT '0' NOT NULL, /*递延月份*/
oct11       varchar2(10) DEFAULT ' ' NOT NULL, /*售货动作代号*/
oct12       number(20,6),            /*总递延收入（本币）                     */
oct12f      number(20,6),            /*总递延收入（原币）                     */
oct13       varchar2(24),            /*递延收入科目                           */
oct14       number(20,6),            /*每期递延收入(本币)                     */
oct14f      number(20,6),            /*每期递延收入(本币)                     */
oct15       number(20,6),            /*每期折让金额（本币）                   */
oct15f      number(20,6),            /*每期折让金额（原币）                   */
oct16       varchar2(1) DEFAULT ' ' NOT NULL, /*异动类型*/
oct17       varchar2(10),            /*营运中心代码                           */
oct18       varchar2(4),             /*原币币种                               */
oct19       number(20,10),           /*汇率                                   */
oct20       varchar2(24),            /*冲转每期递延收入反向科目               */
octlegal    varchar2(10),            /*所属法人                               */
oct22       number(5),               /*传票单身项次                           */
oct23       varchar2(10),            /*客户编号                               */
oct24       varchar2(10)             /*部门编号                               */
);

alter table oct_file add  constraint oct_pk primary key  (oct00,oct01,oct02,oct09,oct10,oct11,oct16) enable validate;
grant select on oct_file to tiptopgp;
grant update on oct_file to tiptopgp;
grant delete on oct_file to tiptopgp;
grant insert on oct_file to tiptopgp;
grant index on oct_file to public;
grant select on oct_file to ods;
