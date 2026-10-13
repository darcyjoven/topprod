/*
================================================================================
檔案代號:rmp_file
檔案名稱:RMA 序号资料销账明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmp_file
(
rmp00       varchar2(1),             /*资料类型                               */
                                     /*資料類別                               */
                                     /*1-RMA覆出單號                          */
                                     /*2-銷退單號                             */
                                     /*3-報廢單號                             */
rmp01       varchar2(20) NOT NULL,   /*销帐单号                               */
                                     /*銷帳單號                               */
rmp011      number(5) NOT NULL,      /*销退单批号                             */
                                     /*銷退單批號                             */
rmp02       number(5) NOT NULL,      /*销帐项次                               */
                                     /*銷帳項次                               */
rmp03       number(5),               /*C/NO                                   */
rmp04       number(5),               /*项次                                   */
                                     /*項次-ref to rmf02                      */
rmp05       varchar2(20),            /*RMA单号                                */
                                     /*RMA單號                                */
rmp06       number(5),               /*RET No.                                */
                                     /*RET#--如rmp00='1'時，可接受0           */
                                     /*如為 0 時，產品編號自動設為MISC        */
rmp07       number(15,3) NOT NULL,   /*覆出数量                               */
                                     /*覆出數量                               */
rmp08       number(15,3) NOT NULL,   /*软盘数量                               */
                                     /*磁片數量                               */
rmp09       varchar2(1),             /*新修复状态                             */
                                     /*新修復狀態                             */
rmp10       varchar2(1),             /*原修复状态                             */
                                     /*原修復狀態                             */
rmp11       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
rmp12       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rmp13       varchar2(120),           /*品名                                   */
                                     /*品名--產品編號=MISC時，可輸入本欄位    */
rmp14       varchar2(120),           /*规格                                   */
                                     /*規格                                   */
rmp15       varchar2(15),            /*S/N                                    */
rmp909      varchar2(1),             /*保税撷取否                             */
                                     /*保稅擷取否                             */
rmpud01     varchar2(255),           /*自订字段-Textedit                      */
rmpud02     varchar2(40),            /*自订字段-文字                          */
rmpud03     varchar2(40),            /*自订字段-文字                          */
rmpud04     varchar2(40),            /*自订字段-文字                          */
rmpud05     varchar2(40),            /*自订字段-文字                          */
rmpud06     varchar2(40),            /*自订字段-文字                          */
rmpud07     number(15,3),            /*自订字段-数值                          */
rmpud08     number(15,3),            /*自订字段-数值                          */
rmpud09     number(15,3),            /*自订字段-数值                          */
rmpud10     number(10),              /*自订字段-整数                          */
rmpud11     number(10),              /*自订字段-整数                          */
rmpud12     number(10),              /*自订字段-整数                          */
rmpud13     date,                    /*自订字段-日期                          */
rmpud14     date,                    /*自订字段-日期                          */
rmpud15     date,                    /*自订字段-日期                          */
rmpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index rmp_02 on rmp_file (rmp05,rmp06);
alter table rmp_file add  constraint rmp_pk primary key  (rmp01,rmp011,rmp02) enable validate;
grant select on rmp_file to tiptopgp;
grant update on rmp_file to tiptopgp;
grant delete on rmp_file to tiptopgp;
grant insert on rmp_file to tiptopgp;
grant index on rmp_file to public;
grant select on rmp_file to ods;
