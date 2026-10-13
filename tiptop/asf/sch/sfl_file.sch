/*
================================================================================
檔案代號:sfl_file
檔案名稱:报废单单身档(工单)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfl_file
(
sfl01       varchar2(20) NOT NULL,   /*报废单号(SCR)                          */
                                     /*報廢單號(SCR)                          */
sfl02       varchar2(20) NOT NULL,   /*工单单号                               */
                                     /*工單單號                               */
sfl03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
sfl031      varchar2(4) NOT NULL,    /*单位                                   */
                                     /*單位(sfa12)                            */
sfl033      number(20,8),            /*发料单位/库存单位换算率                */
                                     /*發料單位/庫存單位換算率                */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sfl04       varchar2(10) NOT NULL,   /*工艺编号                               */
                                     /*製程編號                               */
sfl041      number(5) DEFAULT '0' NOT NULL, /*工艺序号*/
                                     /*製程序號                               */
sfl05       number(15,3) NOT NULL,   /*应发数量                               */
                                     /*應發數量                               */
                                     /*儲存該工單備料料件，使用者經過修改後， */
                                     /*決定的備料量；開始時，應與原發數量相同 */
sfl06       number(15,3) NOT NULL,   /*已发数量                               */
                                     /*已發數量                               */
                                     /*儲存該工單備料料件，已經被發料的數量； */
sfl063      number(15,3) NOT NULL,   /*报废数量                               */
                                     /*報廢數量                               */
                                     /*儲存該工單備料料件，被報廢料的數量     */
sfl07       number(15,3) NOT NULL,   /*本次报废数量                           */
                                     /*本次報廢數量                           */
sfl08       varchar2(10),            /*报废理由码                             */
                                     /*報廢理由碼                             */
sfl09       varchar2(24),            /*报废科目                               */
                                     /*報廢科目                               */
sfl10       varchar2(4),             /*单位一                                 */
sfl11       number(20,8),            /*单位一转换率(与生产单位)               */
sfl12       number(15,3),            /*单位一数量                             */
sfl13       varchar2(4),             /*单位二                                 */
sfl14       number(20,8),            /*单位二转换率(与生产单位)               */
sfl15       number(15,3),            /*单位二数量                             */
sflud01     varchar2(255),           /*自订字段-Textedit                      */
sflud02     varchar2(40),            /*自订字段-文字                          */
sflud03     varchar2(40),            /*自订字段-文字                          */
sflud04     varchar2(40),            /*自订字段-文字                          */
sflud05     varchar2(40),            /*自订字段-文字                          */
sflud06     varchar2(40),            /*自订字段-文字                          */
sflud07     number(15,3),            /*自订字段-数值                          */
sflud08     number(15,3),            /*自订字段-数值                          */
sflud09     number(15,3),            /*自订字段-数值                          */
sflud10     number(10),              /*自订字段-整数                          */
sflud11     number(10),              /*自订字段-整数                          */
sflud12     number(10),              /*自订字段-整数                          */
sflud13     date,                    /*自订字段-日期                          */
sflud14     date,                    /*自订字段-日期                          */
sflud15     date,                    /*自订字段-日期                          */
sflplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfllegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfl012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sfl011      number(5) DEFAULT '0' NOT NULL, /*项次*/
sfl27       varchar2(40) DEFAULT ' ' NOT NULL
);

alter table sfl_file add  constraint sfl_pk primary key  (sfl01,sfl011) enable validate;
grant select on sfl_file to tiptopgp;
grant update on sfl_file to tiptopgp;
grant delete on sfl_file to tiptopgp;
grant insert on sfl_file to tiptopgp;
grant index on sfl_file to public;
grant select on sfl_file to ods;
