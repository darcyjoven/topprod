/*
================================================================================
檔案代號:poy_file
檔案名稱:多角贸易流程代码设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poy_file
(
poy01       varchar2(8) NOT NULL,    /*流程代码                               */
                                     /*流程代碼                               */
poy02       number(5) NOT NULL,      /*站别                                   */
                                     /*站別                                   */
poy03       varchar2(10),            /*下游厂商编号                           */
                                     /*下游廠商編號                           */
poy04       varchar2(10),            /*营运中心编号                           */
                                     /*工廠編號                               */
poy05       varchar2(4),             /*计价币种                               */
                                     /*計價幣別 -> azi01                      */
poy06       varchar2(10),            /*付款条件                               */
                                     /*付款條件                               */
poy07       varchar2(6),             /*收款条件                               */
                                     /*收款條件                               */
poy08       varchar2(4),             /*SO税种                                 */
                                     /*SO稅別                                 */
poy09       varchar2(4),             /*PO税种                                 */
                                     /*PO稅別                                 */
poy10       varchar2(10),            /*销售分类                               */
                                     /*銷售分類                               */
poy11       varchar2(10),            /*仓库                                   */
                                     /*倉庫別                                 */
poy12       varchar2(5),             /*发票别                                 */
poy13       varchar2(1),             /*AP类型                                 */
                                     /*AP類別                                 */
poy14       varchar2(10),            /*营运中心编号                           */
                                     /*工廠編號                               */
poy15       varchar2(4),             /*计价币种                               */
                                     /*計價幣別                               */
                                     /*--------以下為財務預設基本資料----------*/
poy16       varchar2(10),            /*AR科目类型                             */
                                     /*AR科目類別                             */
poy17       varchar2(10),            /*AP科目类型                             */
                                     /*AP科目類別                             */
poy18       varchar2(10),            /*AR部门编号                             */
                                     /*AR部門編號                             */
poy19       varchar2(10),            /*AP部门编号                             */
                                     /*AP部門編號                             */
poy20       varchar2(1),             /*营业额申报方式                         */
                                     /*營業額申報方式                         */
                                     /*1.全額申報 2.差額申報 3.不申報         */
poy21       varchar2(1),             /*No Use                                 */
poy22       varchar2(1),             /*No Use                                 */
poy23       varchar2(1),             /*No Use                                 */
poy24       varchar2(1),             /*No Use                                 */
poy25       varchar2(1),             /*No Use                                 */
poy26       varchar2(1),             /*是否计算业绩                           */
poy27       varchar2(10),            /*业绩归属组织                           */
poy28       varchar2(10),            /*出货理由码                             */
poy29       varchar2(10),            /*代送商编号                             */
poy30       varchar2(10),            /*仓退理由码                             */
poy31       varchar2(10),            /*销退理由码                             */
poy32       varchar2(10),            /*调拨理由码                             */
poy33       varchar2(10),            /*债权代码                               */
poy34       varchar2(5),             /*订单单别                               */
poy35       varchar2(5),             /*采购单单别                             */
poy36       varchar2(5),             /*出单单别                               */
poy37       varchar2(5),             /*收货单单别                             */
poy38       varchar2(5),             /*入库单单别                             */
poy39       varchar2(5),             /*AR单别                                 */
poy40       varchar2(5),             /*AP单别                                 */
poy41       varchar2(5),             /*销退单单别                             */
poy42       varchar2(5),             /*仓销退单单别                           */
poy43       varchar2(5),             /*AR折让单别                             */
poy44       varchar2(5),             /*AP折让单别                             */
poy45       varchar2(10),            /*订单成本中心                           */
poy46       varchar2(10),            /*采购成本中心                           */
poy47       varchar2(5),             /*出货通知单别                           */
poyud01     varchar2(255),           /*自订字段-Textedit                      */
poyud02     varchar2(40),            /*自订字段-文字                          */
poyud03     varchar2(40),            /*自订字段-文字                          */
poyud04     varchar2(40),            /*自订字段-文字                          */
poyud05     varchar2(40),            /*自订字段-文字                          */
poyud06     varchar2(40),            /*自订字段-文字                          */
poyud07     number(15,3),            /*自订字段-数值                          */
poyud08     number(15,3),            /*自订字段-数值                          */
poyud09     number(15,3),            /*自订字段-数值                          */
poyud10     number(10),              /*自订字段-整数                          */
poyud11     number(10),              /*自订字段-整数                          */
poyud12     number(10),              /*自订字段-整数                          */
poyud13     date,                    /*自订字段-日期                          */
poyud14     date,                    /*自订字段-日期                          */
poyud15     date,                    /*自订字段-日期                          */
poy48       varchar2(5),             /*INVOICE单别                            */
poy49       varchar2(5)              /*PACKING单别                            */
);

alter table poy_file add  constraint poy_pk primary key  (poy01,poy02) enable validate;
grant select on poy_file to tiptopgp;
grant update on poy_file to tiptopgp;
grant delete on poy_file to tiptopgp;
grant insert on poy_file to tiptopgp;
grant index on poy_file to public;
grant select on poy_file to ods;
