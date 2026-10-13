/*
================================================================================
檔案代號:ica_file
檔案名稱:ICD参数设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ica_file
(
ica00       varchar2(1) NOT NULL,    /*Key Value(0)                           */
ica01       varchar2(1),             /*刻号/BIN管理                           */
                                     /*NO USE(CHI-920080)                     */
ica02       varchar2(1),             /*工入分仓否                             */
                                     /*NO USE(CHI-920080)                     */
ica03       varchar2(10),            /*工入分仓-非成本仓别                    */
                                     /*NO USE(CHI-920080)                     */
ica04       varchar2(1),             /*订单检查工单否                         */
ica05       varchar2(10),            /*回货暂存仓库                           */
ica06       varchar2(10),            /*回货暂存库位别                         */
ica07       varchar2(1),             /*外编母体冲销合约订单                   */
                                     /*NO USE(CHI-920080)                     */
ica08       varchar2(1),             /*若超过合约订单数量,是否允许            */
                                     /*NO USE(CHI-920080)                     */
ica09       varchar2(1),             /*超过合约订单数量的处理方式             */
                                     /*NO USE(CHI-920080)                     */
ica10       varchar2(1),             /*内编母体冲销Bank PO                    */
                                     /*NO USE(CHI-920080)                     */
ica11       varchar2(1),             /*若超过Bank PO数量,是否允许冲           */
                                     /*NO USE(CHI-920080)                     */
ica12       varchar2(1),             /*超过Blank PO数量的处理方式             */
                                     /*NO USE(CHI-920080)                     */
ica13       varchar2(5),             /*杂发单别                               */
                                     /*NO USE(CHI-920080)                     */
ica14       varchar2(5),             /*杂收单别                               */
                                     /*NO USE(CHI-920080)                     */
ica15       varchar2(10),            /*理由码                                 */
                                     /*NO USE(CHI-920080)                     */
ica16       varchar2(10),            /*Wafer分群码                            */
                                     /*NO USE(CHI-920080)                     */
ica17       varchar2(40),            /*光罩分群码                             */
                                     /*NO USE(CHI-920080)                     */
ica18       varchar2(1),             /*包装单箱数自行维护                     */
                                     /*NO USE(CHI-920080)                     */
ica19       varchar2(1),             /*Date Code生成日期的方式                */
                                     /*NO USE(CHI-920080)                     */
ica20       varchar2(4),             /*no use                                 */
ica21       varchar2(4),             /*no use                                 */
ica22       varchar2(4),             /*no use                                 */
ica23       varchar2(4),             /*no use                                 */
ica24       varchar2(4),             /*no use                                 */
ica25       varchar2(4),             /*no use                                 */
ica26       varchar2(4),             /*no use                                 */
ica27       varchar2(4),             /*no use                                 */
ica28       varchar2(10),            /*工作中心                               */
                                     /*NO USE(CHI-920080)                     */
ica29       varchar2(5),             /*杂发单别                               */
                                     /*NO USE(CHI-920080)                     */
ica30       varchar2(10),            /*理由码                                 */
                                     /*NO USE(CHI-920080)                     */
ica31       varchar2(10),            /*Spare Part 理由码                      */
                                     /*NO USE(CHI-920080)                     */
ica32       varchar2(1),             /*委外FT时,依收货等级取价                */
ica33       varchar2(1),             /*委外采购单是否自动发出                 */
ica35       varchar2(1),             /*no use                                 */
ica36       varchar2(1),             /*no use                                 */
ica37       varchar2(1),             /*no use                                 */
ica38       varchar2(1),             /*no use                                 */
ica39       varchar2(1),             /*no use                                 */
ica40       varchar2(1),             /*是否使用New Code申请流程               */
icaud01     varchar2(255),           /*自订字段-Textedit                      */
icaud02     varchar2(40),            /*自订字段-文字                          */
icaud03     varchar2(40),            /*自订字段-文字                          */
icaud04     varchar2(40),            /*自订字段-文字                          */
icaud05     varchar2(40),            /*自订字段-文字                          */
icaud06     varchar2(40),            /*自订字段-文字                          */
icaud07     number(15,3),            /*自订字段-数值                          */
icaud08     number(15,3),            /*自订字段-数值                          */
icaud09     number(15,3),            /*自订字段-数值                          */
icaud10     number(10),              /*自订字段-整数                          */
icaud11     number(10),              /*自订字段-整数                          */
icaud12     number(10),              /*自订字段-整数                          */
icaud13     date,                    /*自订字段-日期                          */
icaud14     date,                    /*自订字段-日期                          */
icaud15     date,                    /*自订字段-日期                          */
ica41       varchar2(5),             /*委外发料单别                           */
ica042      varchar2(5),             /*委外工单单别                           */
ica43       varchar2(255),           /*回货档案路径                           */
ica44       varchar2(1) DEFAULT 'Y' NOT NULL, /*厂内工单自动产生发料单*/
ica45       varchar2(1) DEFAULT '1' NOT NULL /*回货价格设定*/
);

alter table ica_file add  constraint ica_pk primary key  (ica00) enable validate;
grant select on ica_file to tiptopgp;
grant update on ica_file to tiptopgp;
grant delete on ica_file to tiptopgp;
grant insert on ica_file to tiptopgp;
grant index on ica_file to public;
grant select on ica_file to ods;
