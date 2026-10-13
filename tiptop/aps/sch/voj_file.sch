/*
================================================================================
檔案代號:voj_file
檔案名稱:aps(製令齊料表)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voj_file
(
voj00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voj01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
voj02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voj03       number(9) DEFAULT '0' NOT NULL, /*序号*/
voj04       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
voj05       varchar2(10),            /*限定版本                               */
voj06       date,                    /*供需日期                               */
voj07       number(15,3),            /*订单未交量                             */
voj08       number(15,3),            /*预测需求量                             */
voj09       number(15,3),            /*安全库存量                             */
voj10       number(15,3),            /*atp需求量                              */
voj11       number(15,3),            /*订单未交替他需求量                     */
voj12       number(15,3),            /*预测替他需求量                         */
voj13       number(15,3),            /*atp替他需求量                          */
voj14       number(15,3),            /*计划备料量                             */
voj15       number(15,3),            /*计划备料替他需求量                     */
voj16       number(15,3),            /*工单备料量                             */
voj17       number(15,3),            /*工单备料替他需求量                     */
voj18       number(15,3),            /*备料重排需求减少量                     */
voj19       number(15,3),            /*备料重排需求增加量                     */
voj20       number(15,3),            /*库存量                                 */
voj21       number(15,3),            /*在验量                                 */
voj22       number(15,3),            /*替代库存量                             */
voj23       number(15,3),            /*请购量                                 */
voj24       number(15,3),            /*在采量                                 */
voj25       number(15,3),            /*在外量                                 */
voj26       number(15,3),            /*未发放在制量                           */
voj27       number(15,3),            /*已发放在制量                           */
voj28       number(15,3),            /*替代请购量                             */
voj29       number(15,3),            /*替代采购量                             */
voj30       number(15,3),            /*替代在制量                             */
voj31       number(15,3),            /*交期重排供给减少量                     */
voj32       number(15,3),            /*交期重排供给增加量                     */
voj33       number(15,3),            /*预估结存                               */
voj34       number(15,3),            /*规划采购量                             */
voj35       number(15,3),            /*替代规划采购量                         */
voj36       number(15,3),            /*规划制造量                             */
voj37       number(15,3),            /*替代规划制造量                         */
voj38       number(15,3),            /*预计结存                               */
voj39       number(15,3),            /*规划结存                               */
voj40       varchar2(60),            /*APS保留字段文字                        */
voj41       varchar2(60),            /*APS保留字段文字                        */
voj42       varchar2(60),            /*APS保留字段文字                        */
voj43       number(9),               /*APS保留字段数值                        */
voj44       number(18,8),            /*APS保留字段浮点数                      */
voj45       number(18,8),            /*APS保留字段浮点数                      */
voj46       date,                    /*APS保留字段日期                        */
voj47       date,                    /*APS保留字段日期                        */
vojlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vojplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

grant select on voj_file to tiptopgp;
grant update on voj_file to tiptopgp;
grant delete on voj_file to tiptopgp;
grant insert on voj_file to tiptopgp;
grant index on voj_file to public;
grant select on voj_file to ods;
