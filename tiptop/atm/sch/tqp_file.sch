/*
================================================================================
檔案代號:tqp_file
檔案名稱:合同单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqp_file
(
tqp01       varchar2(20) NOT NULL,   /*合约单号                               */
tqp02       varchar2(80),            /*合约名称                               */
tqp03       varchar2(10),            /*合约类型                               */
tqp04       varchar2(1),             /*状态码                                 */
tqp05       varchar2(10),            /*债权编码                               */
tqp06       date,                    /*合约起始日期                           */
tqp07       date,                    /*合约截止日期                           */
tqp08       varchar2(10),            /*No Use                                 */
tqp09       varchar2(30),            /*No Use                                 */
tqp10       varchar2(1),             /*No Use                                 */
tqp11       number(7,3),             /*No Use                                 */
tqp12       varchar2(1),             /*折扣计算基准                           */
                                     /*1-With-Tax Amount                      */
                                     /*2-Bef-Tax Amount                       */
tqp13       varchar2(255),           /*备注                                   */
tqp14       date,                    /*信用额度起算日期                       */
tqp15       number(5),               /*帐期时间                               */
tqp16       number(5),               /*作业时间                               */
tqp17       varchar2(30),            /*信用等级                               */
tqp18       number(20,6),            /*信用额度                               */
tqp19       varchar2(1),             /*No Use                                 */
tqp20       varchar2(10),            /*结算方式                               */
tqp21       varchar2(4),             /*币种                                   */
tqp22       varchar2(4),             /*税种                                   */
tqp23       number(9,4),             /*税率                                   */
tqp24       number(5),               /*联数                                   */
tqp25       varchar2(1),             /*含税否                                 */
tqpacti     varchar2(1),             /*资料有效码                             */
tqpuser     varchar2(10),            /*资料所有者                             */
tqpgrup     varchar2(10),            /*资料所有部门                           */
tqpmodu     varchar2(10),            /*资料更改者                             */
tqpdate     date,                    /*最后更改日期                           */
tqpud01     varchar2(255),           /*自订字段-Textedit                      */
tqpud02     varchar2(40),            /*自订字段-文字                          */
tqpud03     varchar2(40),            /*自订字段-文字                          */
tqpud04     varchar2(40),            /*自订字段-文字                          */
tqpud05     varchar2(40),            /*自订字段-文字                          */
tqpud06     varchar2(40),            /*自订字段-文字                          */
tqpud07     number(15,3),            /*自订字段-数值                          */
tqpud08     number(15,3),            /*自订字段-数值                          */
tqpud09     number(15,3),            /*自订字段-数值                          */
tqpud10     number(10),              /*自订字段-整数                          */
tqpud11     number(10),              /*自订字段-整数                          */
tqpud12     number(10),              /*自订字段-整数                          */
tqpud13     date,                    /*自订字段-日期                          */
tqpud14     date,                    /*自订字段-日期                          */
tqpud15     date,                    /*自订字段-日期                          */
tqpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqplegal    varchar2(10) NOT NULL,   /*所属法人                               */
tqporiu     varchar2(10),            /*资料建立者                             */
tqporig     varchar2(10)             /*资料建立部门                           */
);

alter table tqp_file add  constraint tqp_pk primary key  (tqp01) enable validate;
grant select on tqp_file to tiptopgp;
grant update on tqp_file to tiptopgp;
grant delete on tqp_file to tiptopgp;
grant insert on tqp_file to tiptopgp;
grant index on tqp_file to public;
grant select on tqp_file to ods;
