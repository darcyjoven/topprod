/*
================================================================================
檔案代號:mma_file
檔案名稱:模具零件需求单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mma_file
(
mma01       varchar2(20) NOT NULL,   /*零件需求单编号                         */
                                     /*零件需求單編號                         */
mma02       varchar2(20),            /*开发运行单号                           */
                                     /*開發執行單號                           */
mma021      varchar2(20),            /*运行工单单号                           */
                                     /*執行工單單號                           */
mma03       number(5),               /*模具工单备料项次                       */
                                     /*模具工單備料項次                       */
mma04       varchar2(1),             /*需求单结案状态                         */
                                     /*Req. Nt Closed Status(Y/N) Closed Can Not Change To Processing*/
mma05       varchar2(40),            /*模具工单备料料件编号                   */
                                     /*模具工單備料料件編號   ima01           */
mma051      varchar2(4),             /*图号板别                               */
                                     /*圖號板別                               */
mma06       varchar2(20),            /*模具编号                               */
                                     /*模具編號 參考用                        */
mma07       date,                    /*开单日期                               */
                                     /*開單日期                               */
mma08       date,                    /*需求日期                               */
mma09       number(15,3) NOT NULL,   /*生产数量                               */
                                     /*生產數量                               */
                                     /*預計投入生產的數量，單位為料件生產單位 */
mma10       varchar2(4),             /*生产单位                               */
                                     /*生產單位                               */
mma11       date,                    /*预计起始生产日期                       */
                                     /*預計起始生產日期 system update         */
                                     /*儲存該工單預計投入生產日期             */
mma12       date,                    /*预计结束生产日期                       */
                                     /*預計結束生產日期 system update         */
                                     /*儲存該工單預計完成生產日期             */
mma13       date,                    /*最近一次作业完工日期                   */
                                     /*最近一次作業完工日期(天) system update */
mma14       varchar2(2),             /*需求类型                               */
                                     /*需求類別 mmi01,mmi03='2'               */
mma15       varchar2(10),            /*需求部门                               */
                                     /*需求部門                               */
mma16       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
mma17       varchar2(1),             /*审核否                                 */
                                     /*Confirm?(Y/N)                          */
mma18       number(5),               /*第一加工项次                           */
                                     /*第一加工項次                           */
mma19       varchar2(1),             /*打印码                                 */
                                     /*列印碼                                 */
mma20       varchar2(1),             /*模治具类型                             */
mma21       varchar2(10),            /*缺省仓库                               */
                                     /*預設倉庫 imd01                         */
mma211      varchar2(10),            /*缺省库位                               */
                                     /*預設儲位                               */
mmaacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code                        */
                                     /*System Maintain                        */
mmauser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
mmagrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
mmamodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
mmadate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
mmaud01     varchar2(255),           /*自订字段-Textedit                      */
mmaud02     varchar2(40),            /*自订字段-文字                          */
mmaud03     varchar2(40),            /*自订字段-文字                          */
mmaud04     varchar2(40),            /*自订字段-文字                          */
mmaud05     varchar2(40),            /*自订字段-文字                          */
mmaud06     varchar2(40),            /*自订字段-文字                          */
mmaud07     number(15,3),            /*自订字段-数值                          */
mmaud08     number(15,3),            /*自订字段-数值                          */
mmaud09     number(15,3),            /*自订字段-数值                          */
mmaud10     number(10),              /*自订字段-整数                          */
mmaud11     number(10),              /*自订字段-整数                          */
mmaud12     number(10),              /*自订字段-整数                          */
mmaud13     date,                    /*自订字段-日期                          */
mmaud14     date,                    /*自订字段-日期                          */
mmaud15     date,                    /*自订字段-日期                          */
mmaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmalegal    varchar2(10) NOT NULL,   /*所属法人                               */
mmaoriu     varchar2(10),            /*资料建立者                             */
mmaorig     varchar2(10)             /*资料建立部门                           */
);

create        index mma_02 on mma_file (mma02,mma021,mma03);
alter table mma_file add  constraint mma_pk primary key  (mma01) enable validate;
grant select on mma_file to tiptopgp;
grant update on mma_file to tiptopgp;
grant delete on mma_file to tiptopgp;
grant insert on mma_file to tiptopgp;
grant index on mma_file to public;
grant select on mma_file to ods;
