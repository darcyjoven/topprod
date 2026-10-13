/*
================================================================================
檔案代號:tlfc_file
檔案名稱:成本計算類型異動成本記錄檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tlfc_file
(
tlfc01      varchar2(40),            /*异动料件代号                           */
tlfc02      number(10),              /*来源状况                               */
tlfc026     varchar2(20),            /*单据编号                               */
tlfc027     number(10),              /*单据项次                               */
tlfc03      number(10),              /*目的状况                               */
tlfc036     varchar2(20),            /*单据编号                               */
tlfc037     number(10),              /*单据项次                               */
tlfc06      date,                    /*单据日期                               */
tlfc07      date,                    /*生成日期                               */
tlfc08      varchar2(8),             /*异动资料生成时间                       */
tlfc09      varchar2(10),            /*异动资料发出者                         */
tlfc13      varchar2(10),            /*异动指令编号                           */
tlfc15      varchar2(24),            /*借方会计科目                           */
tlfc151     varchar2(24),            /*借方会计科目二                         */
tlfc16      varchar2(24),            /*贷方会计科目                           */
tlfc161     varchar2(24),            /*贷方会计科目二                         */
tlfc21      number(20,6),            /*成会异动成本                           */
tlfc211     date,                    /*成会计算日期                           */
tlfc212     varchar2(8),             /*成会计算时间                           */
tlfc2131    varchar2(1),             /*no use                                 */
tlfc2132    varchar2(1),             /*no use                                 */
tlfc214     varchar2(1),             /*no use                                 */
tlfc215     varchar2(1),             /*no use                                 */
tlfc2151    varchar2(1),             /*no use                                 */
tlfc216     varchar2(1),             /*no use                                 */
tlfc2171    varchar2(1),             /*no use                                 */
tlfc2172    varchar2(1),             /*no use                                 */
tlfc221     number(20,6),            /*材料成本                               */
tlfc222     number(20,6),            /*人工成本                               */
tlfc2231    number(20,6),            /*制费一成本                             */
tlfc2232    number(20,6),            /*加工成本                               */
tlfc224     number(20,6),            /*制费二成本                             */
tlfc2241    number(20,6),            /*制费三成本                             */
tlfc2242    number(20,6),            /*制费四成本                             */
tlfc2243    number(20,6),            /*制费五成本                             */
tlfc225     varchar2(1),             /*no use                                 */
tlfc2251    varchar2(1),             /*no use                                 */
tlfc226     varchar2(1),             /*no use                                 */
tlfc2271    varchar2(1),             /*no use                                 */
tlfc2272    varchar2(1),             /*no use                                 */
tlfc229     varchar2(1),             /*no use                                 */
tlfc230     varchar2(1),             /*no use                                 */
tlfc231     varchar2(1),             /*no use                                 */
tlfc902     varchar2(10),            /*仓库                                   */
tlfc903     varchar2(10),            /*库位                                   */
tlfc904     varchar2(24),            /*批号                                   */
tlfc905     varchar2(20),            /*单号                                   */
tlfc906     number(10),              /*项次                                   */
tlfc907     number(10),              /*入出库码                               */
tlfccost    varchar2(40),            /*类别代号(批次号/专案号/利润            */
tlfctype    varchar2(1),             /*成本计算类型                           */
tlfclegal   varchar2(10) NOT NULL    /*所属法人                               */
);

create unique index tlfc_08 on tlfc_file (tlfc01,tlfc02,tlfc03,tlfc06,tlfc13,tlfc902,tlfc903,tlfc904,tlfc905,tlfc906,tlfc907,tlfctype,tlfccost);
grant select on tlfc_file to tiptopgp;
grant update on tlfc_file to tiptopgp;
grant delete on tlfc_file to tiptopgp;
grant insert on tlfc_file to tiptopgp;
grant index on tlfc_file to public;
grant select on tlfc_file to ods;
