/*
================================================================================
檔案代號:idg_file
檔案名稱:回货资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idg_file
(
idg01       varchar2(20) DEFAULT ' ' NOT NULL, /*收货单号*/
idg02       number(5) DEFAULT '0' NOT NULL, /*收货单项次*/
idg03       varchar2(1) DEFAULT ' ' NOT NULL, /*回货状态*/
idg04       varchar2(20),            /*采购单号                               */
idg05       number(5),               /*采购单项次                             */
idg06       varchar2(40),            /*device name                            */
idg07       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
idg08       varchar2(80),            /*testing program                        */
idg09       varchar2(23),            /*runcard no                             */
idg10       varchar2(40),            /*prober card                            */
idg11       varchar2(40),            /*pass bin                               */
idg12       number(5,3),             /*temperature                            */
idg13       number(15,6),            /*alarm yield                            */
idg14       number(15,6),            /*hold yield                             */
idg15       varchar2(40),            /*load board                             */
idg16       date,                    /*finish date                            */
idg17       varchar2(80),            /*转档档名                               */
idg18       varchar2(1),             /*no use                                 */
idg19       varchar2(1),             /*no use                                 */
idg20       varchar2(4) DEFAULT ' ' NOT NULL, /*刻号*/
idg21       varchar2(10) DEFAULT ' ' NOT NULL, /*BIN*/
idg22       varchar2(1),             /*PASS BIN否                             */
idg23       number(15,3),            /*收货数量                               */
idg24       number(15,3),            /*实收数量                               */
idg25       number(15,3),            /*不良品数                               */
idg26       number(15,3),            /*报废数量                               */
idg27       number(15,3),            /*gross die                              */
idg28       varchar2(40),            /*Datecode                               */
idg29       number(15,6),            /*yield                                  */
idg30       varchar2(40),            /*test#                                  */
idg31       number(5),               /*deduct                                 */
idg32       varchar2(1),             /*no use                                 */
idg33       varchar2(1),             /*no use                                 */
idg34       varchar2(1),             /*no use                                 */
idg35       varchar2(1),             /*no use                                 */
idg36       varchar2(10),            /*stk id                                 */
idg37       varchar2(10),            /*alarm bin                              */
idg38       varchar2(1),             /*status                                 */
idg39       varchar2(4),             /*id                                     */
idg40       number(15,3),            /*pass                                   */
idg41       varchar2(10),            /*skip                                   */
idg42       varchar2(20),            /*invoice no                             */
idg43       varchar2(40),            /*os_part no                             */
idg44       varchar2(40),            /*part no                                */
idg45       number(15,3),            /*QTY                                    */
idg46       varchar2(40),            /*lot no                                 */
idg47       date,                    /*ship_date                              */
idg48       number(15,3),            /*Wafer_No                               */
idg49       varchar2(20),            /*receipt_no                             */
idg50       varchar2(20),            /*外包单号                               */
idg51       varchar2(40),            /*等级                                   */
idg52       number(15,3),            /*进货数量                               */
idg53       number(15,3),            /*进货片数                               */
idg54       number(15,3),            /*出货数量                               */
idg55       number(9,4),             /*良率                                   */
idg56       number(20,6),            /*单价                                   */
idg57       number(20,6),            /*金额                                   */
idg58       number(15,3),            /*df1(无探针痕迹)                        */
idg59       number(15,3),            /*df2(墨迹污染)                          */
idg60       number(15,3),            /*df3(焊垫污染)                          */
idg61       number(15,3),            /*df4(刮  伤)                            */
idg62       number(15,3),            /*df5(崩  裂)                            */
idg63       number(15,3),            /*df6(硅粉污染)                          */
idg64       number(15,3),            /*df7(护层不良)                          */
idg65       number(15,3),            /*df8(外物污染)                          */
idg66       number(15,3),            /*df9(破 片)                             */
idg67       number(15,3),            /*df10(暗  裂)                           */
idg68       number(15,3),            /*df11(焊垫氧化)                         */
idg69       number(15,3),            /*df12(焊垫腐蚀)                         */
idg70       number(15,3),            /*df13(切割偏移)                         */
idg71       number(15,3),            /*df14(水  痕)                           */
idg72       number(15,3),            /*df15(液  滴)                           */
idg73       number(15,3),            /*df16(短  少)                           */
idg74       number(15,3),            /*df17(溢  出)                           */
idg75       number(15,3),            /*df18(探针突出)                         */
idg76       number(15,3),            /*df19(缺  角)                           */
idg77       number(15,3),            /*df20(其他1)                            */
idg78       number(15,3),            /*df21(其他2)                            */
idg79       number(15,3),            /*df22(其他3)                            */
idg80       number(15,3),            /*df23(其他4)                            */
idg81       number(15,3),            /*df24(其他5)                            */
idg82       number(15,3),            /*不良品总数                             */
idgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idglegal    varchar2(10) NOT NULL,   /*所属法人                               */
idg83       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
idg84       varchar2(10) DEFAULT ' ' NOT NULL /*库位*/
);

alter table idg_file add  constraint idg_pk primary key  (idg01,idg02,idg03,idg20,idg21,idg83,idg84,idg07) enable validate;
grant select on idg_file to tiptopgp;
grant update on idg_file to tiptopgp;
grant delete on idg_file to tiptopgp;
grant insert on idg_file to tiptopgp;
grant index on idg_file to public;
grant select on idg_file to ods;
