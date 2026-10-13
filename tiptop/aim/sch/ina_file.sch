/*
================================================================================
檔案代號:ina_file
檔案名稱:库存异动单据单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ina_file
(
ina00       varchar2(1),             /*单据类型                               */
                                     /*單據類別 (1/2/3/4/5/6)                 */
                                     /*   1:庫存雜項發料  2:WIP 雜項發料      */
                                     /*   3:庫存雜項收料  4:WIP 雜項收料      */
                                     /*   5:庫存雜項報廢  6:WIP 雜項報廢      */
ina01       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
ina02       date,                    /*扣帐日期                               */
                                     /*扣帳日期                               */
ina03       date,                    /*录入日期                               */
                                     /*輸入日期                               */
ina04       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
ina05       varchar2(1),             /*No Use                                 */
ina06       varchar2(10),            /*项目编号                               */
                                     /*專案編號                               */
ina07       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ina08       varchar2(1),             /*No Use                                 */
ina09       varchar2(1),             /*No Use                                 */
ina10       varchar2(20),            /*工单编号                               */
inaprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
inapost     varchar2(1),             /*过帐码                                 */
                                     /*過帳碼                                 */
                                     /*'Y':已過帳                             */
                                     /*'N':未過帳                             */
                                     /*'X':作廢                               */
inauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
inagrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
inamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
inadate     date,                    /*资料更改者                             */
                                     /*資料更改者                             */
inamksg     varchar2(1),             /*签核否                                 */
ina11       varchar2(10),            /*申请人                                 */
ina1001     varchar2(10),            /*客户编号                               */
ina1003     varchar2(10),            /*送货客户                               */
ina1002     varchar2(10),            /*帐款客户                               */
ina1004     varchar2(10),            /*收款客户                               */
ina1005     varchar2(10),            /*地址码                                 */
ina1006     varchar2(255),           /*地址-1                                 */
ina1007     varchar2(255),           /*地址-2                                 */
ina1008     varchar2(255),           /*地址-3                                 */
ina1009     varchar2(10),            /*债权代码                               */
ina1010     varchar2(10),            /*客户所属组织                           */
ina1011     varchar2(10),            /*费用归属组织                           */
ina1012     varchar2(10),            /*客户所属通路                           */
ina1013     date,                    /*预计发出日                             */
ina1014     date,                    /*实际发出日                             */
ina1015     number(15,3),            /*重量                                   */
ina1016     number(15,3),            /*体积                                   */
ina1017     varchar2(20),            /*手工单号                               */
ina1018     varchar2(20),            /*杂发申请单号                           */
ina1019     varchar2(15),            /*非直营业KAB                            */
ina1020     number(20,6),            /*库存异动总金额                         */
ina1021     varchar2(1),             /*已打印提单                             */
ina1022     varchar2(1),             /*导物流状况码                           */
ina1023     varchar2(4),             /*币种                                   */
ina1024     number(20,10),           /*汇率                                   */
ina1025     varchar2(1),             /*异动类型                               */
inaconf     varchar2(1),             /*确认码                                 */
inaspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
ina100      varchar2(10),            /*保税异动原因代码                       */
ina101      varchar2(30),            /*保税进口报单                           */
ina102      date,                    /*保税进口报单日期                       */
inaud01     varchar2(255),           /*自订字段-Textedit                      */
inaud02     varchar2(40),            /*自订字段-文字                          */
inaud03     varchar2(40),            /*自订字段-文字                          */
inaud04     varchar2(40),            /*自订字段-文字                          */
inaud05     varchar2(40),            /*自订字段-文字                          */
inaud06     varchar2(40),            /*自订字段-文字                          */
inaud07     number(15,3),            /*自订字段-数值                          */
inaud08     number(15,3),            /*自订字段-数值                          */
inaud09     number(15,3),            /*自订字段-数值                          */
inaud10     number(10),              /*自订字段-整数                          */
inaud11     number(10),              /*自订字段-整数                          */
inaud12     number(10),              /*自订字段-整数                          */
inaud13     date,                    /*自订字段-日期                          */
inaud14     date,                    /*自订字段-日期                          */
inaud15     date,                    /*自订字段-日期                          */
ina103      varchar2(20),            /*VMI发/退料单号                         */
ina12       varchar2(1) DEFAULT 'N' NOT NULL,
inacond     date,                    /*审核日期                               */
inacont     varchar2(8),             /*审核时间                               */
inaconu     varchar2(10),            /*审核人员                               */
inapos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
inaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
inalegal    varchar2(10) NOT NULL,   /*所属法人                               */
inaoriu     varchar2(10),            /*资料建立者                             */
inaorig     varchar2(10),            /*资料建立部门                           */
ina13       varchar2(20)             /*POS单号                                */
);

create        index ina_02 on ina_file (ina02);
alter table ina_file add  constraint ina_pk primary key  (ina01) enable validate;
grant select on ina_file to tiptopgp;
grant update on ina_file to tiptopgp;
grant delete on ina_file to tiptopgp;
grant insert on ina_file to tiptopgp;
grant index on ina_file to public;
grant select on ina_file to ods;
