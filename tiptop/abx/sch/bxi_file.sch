/*
================================================================================
檔案代號:bxi_file
檔案名稱:撷取后保税异动单据单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bxi_file
(
bxi01       varchar2(20) NOT NULL,   /*单据号码                               */
bxi02       date,                    /*异动日期                               */
bxi03       varchar2(10),            /*客户/厂商编号                          */
bxi04       varchar2(20),            /*发票号码                               */
bxi05       varchar2(20),            /*异动指令                               */
bxi06       varchar2(1),             /*入出仓库                               */
                                     /*1:入庫, 2:出庫                         */
bxi07       varchar2(10),            /*No Use                                 */
bxi08       varchar2(10),            /*保税异动原因代码                       */
bxi09       varchar2(21),            /*来源营运中心编号                       */
                                     /*例 'ds2  :'                            */
bxiconf     varchar2(1),             /*审核否                                 */
                                     /*Y/N                                    */
bxi11       number(5),               /*申报年度                               */
bxi12       number(5),               /*申报月份                               */
bxi13       varchar2(10),            /*收货客户/付款厂商                      */
bxi14       varchar2(255),           /*备注                                   */
bxi15       varchar2(1),             /*异动指令作业别                         */
                                     /*1.雜收(aimt302,aimt312)                */
                                     /*2.雜發(aimt301,aimt311)                */
                                     /*3.報廢(aimt303,aimt313)                */
                                     /*4.工單發料(asfi511,12,13,14)           */
                                     /*5.工單退料(asfi526,27,28,29)           */
                                     /*6.完工入庫(asft6201)                   */
                                     /*7.採購入庫(apmt150,apmt230)            */
                                     /*8.採購倉退(apmt1072)                   */
                                     /*9.銷貨(axmt620,axmt650)                */
                                     /*A.銷貨退回(aomt800)                    */
                                     /*B.其它                                 */
                                     /*#FUN-6A0007                            */
bxiud01     varchar2(255),           /*自订字段-Textedit                      */
bxiud02     varchar2(40),            /*自订字段-文字                          */
bxiud03     varchar2(40),            /*自订字段-文字                          */
bxiud04     varchar2(40),            /*自订字段-文字                          */
bxiud05     varchar2(40),            /*自订字段-文字                          */
bxiud06     varchar2(40),            /*自订字段-文字                          */
bxiud07     number(15,3),            /*自订字段-数值                          */
bxiud08     number(15,3),            /*自订字段-数值                          */
bxiud09     number(15,3),            /*自订字段-数值                          */
bxiud10     number(10),              /*自订字段-整数                          */
bxiud11     number(10),              /*自订字段-整数                          */
bxiud12     number(10),              /*自订字段-整数                          */
bxiud13     date,                    /*自订字段-日期                          */
bxiud14     date,                    /*自订字段-日期                          */
bxiud15     date,                    /*自订字段-日期                          */
bxiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bxilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index bxi_02 on bxi_file (bxi02);
alter table bxi_file add  constraint bxi_pk primary key  (bxi01) enable validate;
grant select on bxi_file to tiptopgp;
grant update on bxi_file to tiptopgp;
grant delete on bxi_file to tiptopgp;
grant insert on bxi_file to tiptopgp;
grant index on bxi_file to public;
grant select on bxi_file to ods;
