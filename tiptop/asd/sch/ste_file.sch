/*
================================================================================
檔案代號:ste_file
檔案名稱:未结工单月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ste_file
(
ste01       varchar2(2),             /*工单类型                               */
                                     /*工單類別                               */
ste02       number(5) NOT NULL,      /*年度                                   */
ste03       number(5) NOT NULL,      /*月份                                   */
ste04       varchar2(20) NOT NULL,   /*工单号码                               */
                                     /*工單號碼                               */
ste05       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
ste06       number(15,3),            /*期初数量                               */
                                     /*期初數量                               */
ste07       number(20,6),            /*期初成本-材料                          */
ste08       number(20,6),            /*期初成本-人工                          */
ste09       number(20,6),            /*期初成本-制费一                        */
                                     /*期初成本-製費一                        */
ste10       number(20,6),            /*期初成本-制费二                        */
                                     /*期初成本-製費二                        */
ste11       number(15,3),            /*本月投入数量                           */
                                     /*本月投入數量                           */
ste12       number(20,6),            /*本月投入成本-材料                      */
ste13       number(20,6),            /*本月投入成本-人工                      */
ste14       number(20,6),            /*本月投入成本-制费一                    */
                                     /*本月投入成本-製費一(含加工費用)        */
ste15       number(20,6),            /*本月投入成本-制费二                    */
                                     /*本月投入成本-製費二                    */
ste16       number(15,3),            /*本月完工数量                           */
                                     /*本月完工數量                           */
ste17       number(20,6),            /*本月完工成本-材料                      */
ste18       number(20,6),            /*本月完工成本-人工                      */
ste19       number(20,6),            /*本月完工成本-制费一                    */
                                     /*本月完工成本-製費一                    */
ste20       number(20,6),            /*本月完工成本-制费二                    */
                                     /*本月完工成本-製費二                    */
ste22       number(20,6),            /*差异成本-材料                          */
                                     /*差異成本-材料                          */
ste23       number(20,6),            /*差异成本-人工                          */
                                     /*差異成本-人工                          */
ste24       number(20,6),            /*差异成本-制费一                        */
                                     /*差異成本-製費一                        */
ste25       number(20,6),            /*差异成本-制费二                        */
                                     /*差異成本-製費二                        */
ste26       number(15,3),            /*期末数量                               */
                                     /*期末數量                               */
ste27       number(20,6),            /*期末成本-材料                          */
ste28       number(20,6),            /*期末成本-人工                          */
ste29       number(20,6),            /*期末成本-制费一                        */
                                     /*期末成本-製費一                        */
ste30       number(20,6),            /*期末成本-制费二                        */
                                     /*期末成本-製費二                        */
ste31       varchar2(1),             /*结案否                                 */
                                     /*結案否                                 */
ste32       number(20,6),            /*本月投入加工费用                       */
                                     /*本月投入加工費用                       */
steplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ste_03 on ste_file (ste04);
create        index ste_02 on ste_file (ste02,ste03);
alter table ste_file add  constraint ste_pk primary key  (ste04,ste02,ste03) enable validate;
grant select on ste_file to tiptopgp;
grant update on ste_file to tiptopgp;
grant delete on ste_file to tiptopgp;
grant insert on ste_file to tiptopgp;
grant index on ste_file to public;
grant select on ste_file to ods;
