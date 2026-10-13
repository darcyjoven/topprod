/*
================================================================================
檔案代號:snb_file
檔案名稱:工单变更单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table snb_file
(
snb01       varchar2(20) NOT NULL,   /*工单单号                               */
                                     /*工單單號                               */
snb02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
snb022      date,                    /*变更日期                               */
                                     /*變更日期                               */
snb04       varchar2(1),             /*变更类型                               */
                                     /*變更類型                               */
                                     /*1.工單單頭變更(asft801)                */
                                     /*2.工單單身變更(asft802)                */
snb08b      number(15,3),            /*变更前生产数量                         */
                                     /*變更前生產數量                         */
snb13b      date,                    /*变更前预计开工日                       */
                                     /*變更前預計開工日                       */
snb15b      date,                    /*变更前预计完工日                       */
                                     /*變更前預計完工日                       */
snb34b      number(9,4),             /*变更前C/R 比率                         */
                                     /*變更前C/R 比率(%)                      */
snb40b      number(5),               /*变更前优先顺序                         */
                                     /*變更前優先順序                         */
snb82b      varchar2(10),            /*变更前制造部门/委外厂商                */
                                     /*變更前製造部門/委外廠商                */
snb98b      varchar2(10),            /*变更前成本中心                         */
                                     /*變更前成本中心                         */
snb08a      number(15,3),            /*变更后生产数量                         */
                                     /*變更後生產數量                         */
snb13a      date,                    /*变更后预计开工日                       */
                                     /*變更後預計開工日                       */
snb15a      date,                    /*变更后预计完工日                       */
                                     /*變更後預計完工日                       */
snb34a      number(9,4),             /*变更后C/R 比率                         */
                                     /*變更後C/R 比率(%)                      */
snb40a      number(5),               /*变更后优先顺序                         */
                                     /*變更後優先順序                         */
snb82a      varchar2(10),            /*变更后制造部门/委外厂商                */
                                     /*變更後製造部門/委外廠商                */
snb98a      varchar2(10),            /*变更后成本中心                         */
                                     /*變更後成本中心                         */
snbconf     varchar2(1),             /*审核                                   */
                                     /*確認(Y/N/X)                            */
snbuser     varchar2(10),            /*资料所有者                             */
snbgrup     varchar2(10),            /*资料所有部门                           */
snbmodu     varchar2(10),            /*资料更改者                             */
snbdate     date,                    /*最近更改日                             */
snbud01     varchar2(255),           /*自订字段-Textedit                      */
snbud02     varchar2(40),            /*自订字段-文字                          */
snbud03     varchar2(40),            /*自订字段-文字                          */
snbud04     varchar2(40),            /*自订字段-文字                          */
snbud05     varchar2(40),            /*自订字段-文字                          */
snbud06     varchar2(40),            /*自订字段-文字                          */
snbud07     number(15,3),            /*自订字段-数值                          */
snbud08     number(15,3),            /*自订字段-数值                          */
snbud09     number(15,3),            /*自订字段-数值                          */
snbud10     number(10),              /*自订字段-整数                          */
snbud11     number(10),              /*自订字段-整数                          */
snbud12     number(10),              /*自订字段-整数                          */
snbud13     date,                    /*自订字段-日期                          */
snbud14     date,                    /*自订字段-日期                          */
snbud15     date,                    /*自订字段-日期                          */
snb99       varchar2(1),             /*签核状况                               */
snbmksg     varchar2(1),             /*是否签核                               */
snbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
snblegal    varchar2(10) NOT NULL,   /*所属法人                               */
snboriu     varchar2(10),            /*资料建立者                             */
snborig     varchar2(10),            /*资料建立部门                           */
snb14a      varchar2(5),             /*变更后预计开工时间                     */
snb14b      varchar2(5),             /*变更前预计开工时间                     */
snb16a      varchar2(5),             /*变更后预计完工时间                     */
snb16b      varchar2(5),             /*变更后预计完工时间                     */
snbsendd    date,                    /*发出日期                               */
snbsendt    varchar2(8),             /*发出时间                               */
snbsendu    varchar2(10)             /*发出人员                               */
);

alter table snb_file add  constraint snb_pk primary key  (snb01,snb02) enable validate;
grant select on snb_file to tiptopgp;
grant update on snb_file to tiptopgp;
grant delete on snb_file to tiptopgp;
grant insert on snb_file to tiptopgp;
grant index on snb_file to public;
grant select on snb_file to ods;
