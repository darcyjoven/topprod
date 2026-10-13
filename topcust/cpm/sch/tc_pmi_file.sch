/*
================================================================================
檔案代號:tc_pmi_file
檔案名稱:核價單單頭檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_pmi_file
(
tc_pmi01    varchar2(20) NOT NULL,   /*核價單號                               */
tc_pmi02    date,                    /*核價日期                               */
tc_pmi03    varchar2(10),            /*廠商編號                               */
tc_pmi04    varchar2(255),           /*備註                                   */
tc_pmi05    varchar2(1),             /*分量計價                               */
                                     /*分量計價Y/N #NO:7178                   */
tc_pmi06    varchar2(1),             /*狀況碼                                 */
                                     /*狀況碼      #NO:6686                   */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                                */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
tc_pmi07    varchar2(1),             /*簽核否                                 */
                                     /*簽核否      #NO:6686                   */
tc_pmiconf  varchar2(1),             /*確認碼                                 */
                                     /*確認碼(Y/N/X) X.作廢                   */
tc_pmiacti  varchar2(1),             /*資料有效碼                             */
tc_pmiuser  varchar2(10),            /*資料所有者                             */
tc_pmigrup  varchar2(10),            /*資料所有部門                           */
tc_pmimodu  varchar2(10),            /*資料修改者                             */
tc_pmidate  date,                    /*最近修改日                             */
tc_pmi08    varchar2(4),             /*稅別                                   */
tc_pmi081   number(9,4),             /*稅率                                   */
tc_pmi09    varchar2(10),            /*申請人                                 */
tc_pmi10    varchar2(1),             /*價格型態                               */
                                     /*1.採購  2. 委外                        */
tc_pmiplant varchar2(10) NOT NULL,   /*所屬營運中心                           */
tc_pmilegal varchar2(10) NOT NULL,   /*所屬法人                               */
tc_pmioriu  varchar2(10),            /*資料建立者                             */
tc_pmiorig  varchar2(10)             /*資料建立部門                           */
);

alter table tc_pmi_file add  constraint tpc_pmi_pk primary key  (tc_pmi01) enable validate;
grant select on tc_pmi_file to tiptopgp;
grant update on tc_pmi_file to tiptopgp;
grant delete on tc_pmi_file to tiptopgp;
grant insert on tc_pmi_file to tiptopgp;
grant index on tc_pmi_file to public;
grant select on tc_pmi_file to ods;
