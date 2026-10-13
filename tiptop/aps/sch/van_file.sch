/*
================================================================================
檔案代號:van_file
檔案名稱:aps途程製程
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table van_file
(
van01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
van02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
van03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
van04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
van05       date,                    /*生效日                                 */
van06       date,                    /*失效日                                 */
van07       varchar2(10),            /*资源编号                               */
van08       varchar2(60),            /*资源群组编号                           */
van09       number(1),               /*是否批次加工作业                       */
van10       number(15,3),            /*整备时间                               */
van11       number(15,3),            /*加工时间                               */
van12       number(9),               /*移转批量大小                           */
van13       number(9),               /*基准数量                               */
van14       number(1),               /*外包作业                               */
van15       number(9),               /*替代作业的优先次序                     */
van16       number(9),               /*批次加工上限                           */
van17       number(9),               /*批次加工下限                           */
van18       varchar2(40),            /*TIPTOP 料号                            */
van19       varchar2(20),            /*TIPTOP工艺路线编号                     */
van20       varchar2(60),            /*规格一                                 */
van21       varchar2(60),            /*规格二                                 */
van22       varchar2(60),            /*规格三                                 */
van23       varchar2(60),            /*规格四                                 */
van24       varchar2(60),            /*规格五                                 */
van25       varchar2(10),            /*外包商编号                             */
van26       number(9),               /*批量后置时间                           */
van27       varchar2(60),            /*作业名称                               */
van28       varchar2(60),            /*APS保留字段文字                        */
van29       varchar2(60),            /*APS保留字段文字                        */
van30       varchar2(60),            /*APS保留字段文字                        */
van31       number(9),               /*APS保留字段数值                        */
van32       number(18,8),            /*APS保留字段浮点数                      */
van33       number(18,8),            /*APS保留字段浮点数                      */
van34       date,                    /*APS保留字段日期                        */
van35       date,                    /*APS保留字段日期                        */
vanlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vanplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
van36       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
van37       varchar2(10),            /*下工艺段号                             */
van38       number(16,8),            /*组成用量                               */
van39       number(16,8)             /*底数                                   */
);

alter table van_file add  constraint van_pk primary key  (vanlegal,vanplant,van01,van02,van03,van04,van36) enable validate;
grant select on van_file to tiptopgp;
grant update on van_file to tiptopgp;
grant delete on van_file to tiptopgp;
grant insert on van_file to tiptopgp;
grant index on van_file to public;
grant select on van_file to ods;
