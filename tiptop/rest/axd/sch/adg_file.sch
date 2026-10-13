/*
================================================================================
檔案代號:adg_file
檔案名稱:集團撥出單單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adg_file
(
adg01       varchar2(16),            /*撥出單號                               */
adg02       number(5),               /*撥出單項次                             */
adg03       varchar2(16),            /*申請單號                               */
adg04       number(5),               /*申請項次                               */
adg05       varchar2(40),            /*料件編號                               */
adg06       varchar2(10),            /*倉庫代號                               */
adg07       varchar2(10),            /*儲位                                   */
adg08       varchar2(20),            /*批號                                   */
adg09       varchar2(10),            /*撥入營運中心編號                       */
adg10       varchar2(10),            /*撥入營運中心倉庫                       */
adg11       varchar2(4),             /*單位                                   */
adg12       number(15,3),            /*撥出數量                               */
adg13       varchar2(1),             /*轉撥計價方式                           */
adg14       number(7,4),             /*轉撥百分比                             */
adg15       number(20,6),            /*撥出單價                               */
adg16       number(20,6),            /*撥出金額                               */
adg17       number(15,3),            /*已撥入數量                             */
adg18       varchar2(1),             /*計劃期別格式                           */
adg19       number(10),              /*起始期別                               */
adg20       number(5),               /*序號                                   */
adg21       varchar2(1),             /*No Use                                 */
adg22       varchar2(1),             /*No Use                                 */
adg23       varchar2(1),             /*No Use                                 */
adg30       varchar2(4),             /*單位一                                 */
adg31       number(16,8),            /*單位一轉換率(與庫存單位)               */
adg32       number(15,3),            /*單位一數量                             */
adg33       varchar2(4),             /*單位二                                 */
adg34       number(16,8),            /*單位二轉換率(與庫存單位)               */
adg35       number(15,3)             /*單位二數量                             */
);

create unique index adg_01 on adg_file (adg01,adg02);
create        index adg_02 on adg_file (adg03,adg04);
grant select on adg_file to public;
grant index on adg_file to public;
grant update on adg_file to public;
grant delete on adg_file to public;
grant insert on adg_file to public;
