/*
================================================================================
檔案代號:fbz_file
檔案名稱:资产异动缺省科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fbz_file
(
fbz00       varchar2(1) NOT NULL,    /*KEY VALUE = '0'                        */
fbz05       varchar2(24),            /*改良对方科目                           */
fbz06       varchar2(24),            /*重估对方科目                           */
fbz07       varchar2(24),            /*调整对方科目                           */
fbz08       varchar2(24),            /*报废对方科目                           */
fbz09       varchar2(24),            /*销帐对方科目                           */
fbz10       varchar2(24),            /*出售应收科目                           */
fbz11       varchar2(24),            /*出售收益科目                           */
fbz12       varchar2(24),            /*出售损失                               */
fbz13       varchar2(24),            /*保险费用科目                           */
fbz14       varchar2(24),            /*预付保费科目                           */
fbz15       varchar2(24),            /*利息资本贷方科目                       */
fbzacti     varchar2(1),             /*资料有效码                             */
fbzuser     varchar2(10),            /*资料所有者                             */
fbzgrup     varchar2(10),            /*资料所有群                             */
fbzmodu     varchar2(10),            /*资料更改者                             */
fbzdate     date,                    /*最近更改日                             */
fbz16       varchar2(24),            /*利息支出                               */
fbz17       varchar2(24),            /*减值准备对方科目                       */
                                     /*Devalue Preparative Counterpart Account #No:A099*/
fbz18       varchar2(24),            /*固定资产清理科目                       */
                                     /*Fixed Asset Cleaning Account #No:A099  */
fbz19       varchar2(24),            /*No Use                                 */
fbz20       varchar2(24),            /*No Use                                 */
fbz051      varchar2(24),            /*改良对方科目二                         */
fbz061      varchar2(24),            /*重估对方科目二                         */
fbz071      varchar2(24),            /*调整对方科目二                         */
fbz081      varchar2(24),            /*报废对方科目二                         */
fbz091      varchar2(24),            /*销帐对方科目二                         */
fbz101      varchar2(24),            /*出售应收科目二                         */
fbz111      varchar2(24),            /*出售收益科目二                         */
fbz121      varchar2(24),            /*出售损失二                             */
fbz131      varchar2(24),            /*保险费用科目二                         */
fbz141      varchar2(24),            /*预付保费科目二                         */
fbz151      varchar2(24),            /*利息资本贷方科目二                     */
fbz171      varchar2(24),            /*减值准备对方科目二                     */
fbz181      varchar2(24),            /*固定資產清理科目二                     */
fbz161      varchar2(24),            /*利息支出二                             */
fbzorig     varchar2(10),            /*资料建立部门                           */
fbzoriu     varchar2(10)             /*资料建立者                             */
);

alter table fbz_file add  constraint fbz_pk primary key  (fbz00) enable validate;
grant select on fbz_file to tiptopgp;
grant update on fbz_file to tiptopgp;
grant delete on fbz_file to tiptopgp;
grant insert on fbz_file to tiptopgp;
grant index on fbz_file to public;
grant select on fbz_file to ods;
