/*
================================================================================
檔案代號:vod_file
檔案名稱:aps(需求訂單結果)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vod_file
(
vod00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vod01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vod02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vod03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vod04       number(15,3),            /*需求数量                               */
vod05       varchar2(20),            /*工单单号(erp)                          */
vod06       date,                    /*预计完工日期（erp）                    */
vod07       date,                    /*预计开立日期（erp）                    */
vod08       number(1),               /*开立否                                 */
vod09       varchar2(40),            /*完成品料号                             */
vod10       date,                    /*系统规划预计完工时间                   */
vod11       date,                    /*系统规划预计发放时间                   */
vod12       number(5),               /*优先顺序                               */
vod13       number(15,3),            /*开立数量                               */
vod14       varchar2(80),            /*工艺路线                               */
vod15       number(1),               /*品项类型                               */
vod16       varchar2(4),             /*计数单位                               */
vod17       number(1),               /*是否完全发料                           */
vod18       number(1),               /*是否atp需求订单                        */
vod19       varchar2(60),            /*计画批号                               */
vod20       varchar2(60),            /*工单供给的需求订单号                   */
vod21       varchar2(60),            /*此工单供给的上阶制令号                 */
vod22       varchar2(60),            /*主要来源需求订单号                     */
vod23       number(15,3),            /*已生产量                               */
vod24       number(15,3),            /*可用量                                 */
vod25       number(15,3),            /*报废数量                               */
vod26       varchar2(10),            /*拥有者                                 */
vod27       number(1),               /*工单运行状态                           */
vod28       varchar2(4),             /*APS规划时单位                          */
vod29       number(20,8),            /*转换率(库存/生产)                      */
vod30       date,                    /*backward递推时的完工日                 */
vod31       date,                    /*采购限制日期                           */
vod32       number(15,3),            /*主料替他量                             */
vod33       number(15,3),            /*预计短缺量                             */
vod34       number(15,3),            /*实际耗用量                             */
vod35       number(15,3),            /*建议开立量                             */
vod36       varchar2(10),            /*新拥有者                               */
vod37       varchar2(1),             /*变更否                                 */
vod38       varchar2(20),            /*产生的工单单号                         */
vod39       number(1),               /*有无工艺                               */
vod40       number(15,3),            /*MOD订单耗用量                          */
vod41       varchar2(60),            /*供给法则                               */
vod42       number(1),               /*外包码                                 */
vod43       varchar2(60),            /*APS保留字段文字                        */
vod44       varchar2(60),            /*APS保留字段文字                        */
vod45       varchar2(60),            /*APS保留字段文字                        */
vod46       number(9),               /*APS保留字段数值                        */
vod47       number(18,8),            /*APS保留字段浮点数                      */
vod48       number(18,8),            /*APS保留字段浮点数                      */
vod49       date,                    /*APS保留字段日期                        */
vod50       date,                    /*APS保留字段日期                        */
vodlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vodplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vod_file add  constraint vod_pk primary key  (vod00,vod01,vod02,vod03) enable validate;
grant select on vod_file to tiptopgp;
grant update on vod_file to tiptopgp;
grant delete on vod_file to tiptopgp;
grant insert on vod_file to tiptopgp;
grant index on vod_file to public;
grant select on vod_file to ods;
