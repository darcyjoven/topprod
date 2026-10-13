/*
================================================================================
檔案代號:idh_file
檔案名稱:ICD回货资料暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idh_file
(
idh001      varchar2(20) DEFAULT ' ' NOT NULL, /*档案名称*/
idh0011     number(5) DEFAULT '0' NOT NULL, /*资料顺序*/
idh002      varchar2(255),           /*路径                                   */
idh003      varchar2(1),             /*回货状态                               */
idh004      varchar2(20),            /*采购单号                               */
idh005      number(5),               /*采购单项次                             */
idh006      varchar2(40),            /*no use                                 */
idh007      varchar2(24),            /*批号                                   */
idh008      varchar2(30),            /*Testing Program                        */
idh009      varchar2(23),            /*RunCard No                             */
idh010      varchar2(40),            /*Prober Card                            */
idh011      varchar2(40),            /*PASS BIN                               */
idh012      number(5,3),             /*Temperature                            */
idh013      number(15,3),            /*Alarm yield                            */
idh014      number(9,4),             /*Hold Yield                             */
idh015      varchar2(40),            /*Load Board                             */
idh016      date,                    /*Finish date                            */
idh017      varchar2(20),            /*收货单                                 */
idh018      number(5),               /*收货单项次                             */
idh019      varchar2(1),             /*no use                                 */
idh020      varchar2(255),           /*刻号                                   */
idh021      varchar2(255),           /*BIN                                    */
idh022      varchar2(1),             /*PASS BIN否                             */
idh023      number(15,3),            /*nouse                                  */
idh024      number(15,3),            /*Pass-出货数量                          */
idh025      number(15,3),            /*不良品数                               */
idh026      number(15,3),            /*报废数量                               */
idh027      number(15,3),            /*Gross die                              */
idh028      varchar2(40),            /*Datecode                               */
idh029      number(9,4),             /*Yield                                  */
idh030      varchar2(40),            /*Test#                                  */
idh031      varchar2(10),            /*deduct                                 */
idh032      varchar2(1),             /*no use                                 */
idh033      varchar2(1),             /*no use                                 */
idh034      varchar2(1),             /*no use                                 */
idh035      varchar2(1),             /*no use                                 */
idh036      number(15,3),            /*Bin1                                   */
idh037      number(15,3),            /*Bin2                                   */
idh038      number(15,3),            /*Bin3                                   */
idh039      number(15,3),            /*Bin4                                   */
idh040      number(15,3),            /*Bin5                                   */
idh041      number(15,3),            /*Bin6                                   */
idh042      number(15,3),            /*Bin7                                   */
idh043      number(15,3),            /*Bin8                                   */
idh044      number(15,3),            /*Bin9                                   */
idh045      number(15,3),            /*Bin10                                  */
idh046      number(15,3),            /*Bin11                                  */
idh047      number(15,3),            /*Bin12                                  */
idh048      number(15,3),            /*Bin13                                  */
idh049      number(15,3),            /*Bin14                                  */
idh050      number(15,3),            /*Bin15                                  */
idh051      number(15,3),            /*Bin16                                  */
idh052      number(15,3),            /*Bin17                                  */
idh053      number(15,3),            /*Bin18                                  */
idh054      number(15,3),            /*Bin19                                  */
idh055      number(15,3),            /*Bin20                                  */
idh056      number(15,3),            /*Bin21                                  */
idh057      number(15,3),            /*Bin22                                  */
idh058      number(15,3),            /*Bin23                                  */
idh059      number(15,3),            /*Bin24                                  */
idh060      number(15,3),            /*Bin25                                  */
idh061      number(15,3),            /*Bin26                                  */
idh062      number(15,3),            /*Bin27                                  */
idh063      number(15,3),            /*Bin28                                  */
idh064      number(15,3),            /*Bin29                                  */
idh065      number(15,3),            /*Bin30                                  */
idh066      number(15,3),            /*Bin31                                  */
idh067      number(15,3),            /*Bin32                                  */
idh068      number(15,3),            /*Bin33                                  */
idh069      number(15,3),            /*Bin34                                  */
idh070      number(15,3),            /*Bin35                                  */
idh071      number(15,3),            /*Bin36                                  */
idh072      number(15,3),            /*Bin37                                  */
idh073      number(15,3),            /*Bin38                                  */
idh074      number(15,3),            /*Bin39                                  */
idh075      number(15,3),            /*Bin40                                  */
idh076      number(15,3),            /*Bin41                                  */
idh077      number(15,3),            /*Bin42                                  */
idh078      number(15,3),            /*Bin43                                  */
idh079      number(15,3),            /*Bin44                                  */
idh080      number(15,3),            /*Bin45                                  */
idh081      number(15,3),            /*Bin46                                  */
idh082      number(15,3),            /*Bin47                                  */
idh083      number(15,3),            /*Bin48                                  */
idh084      number(15,3),            /*Bin49                                  */
idh085      number(15,3),            /*Bin50                                  */
idh086      number(15,3),            /*Bin51                                  */
idh087      number(15,3),            /*Bin52                                  */
idh088      number(15,3),            /*Bin53                                  */
idh089      number(15,3),            /*Bin54                                  */
idh090      number(15,3),            /*Bin55                                  */
idh091      number(15,3),            /*Bin56                                  */
idh092      number(15,3),            /*Bin57                                  */
idh093      number(15,3),            /*Bin58                                  */
idh094      number(15,3),            /*Bin59                                  */
idh095      number(15,3),            /*Bin99(other)                           */
idh096      varchar2(10),            /*STK ID                                 */
idh097      varchar2(10),            /*Alarm Bin                              */
idh098      varchar2(1),             /*STATUS                                 */
idh099      number(5),               /*ID                                     */
idh101      number(15,3),            /*pass                                   */
idh102      varchar2(10),            /*skip                                   */
idh103      varchar2(20),            /*invoice no                             */
idh104      varchar2(80),            /*os_part no                             */
idh105      varchar2(80),            /*finish_partno                          */
idh106      number(15,3),            /*QTY                                    */
idh107      varchar2(24),            /*no use                                 */
idh108      date,                    /*ship_date                              */
idh109      number(15,3),            /*Wafer_No                               */
idh110      varchar2(20),            /*receipt_no                             */
idh111      varchar2(20),            /*外包单号                               */
idh112      varchar2(80),            /*等级                                   */
idh113      number(15,3),            /*进货数量                               */
idh114      number(15,3),            /*进货片数                               */
idh115      number(15,3),            /*出货数量                               */
idh116      number(9,4),             /*良率                                   */
idh117      number(20,6),            /*单价                                   */
idh118      number(20,6),            /*金额                                   */
idh119      number(15,3),            /*df1(无探针痕迹)                        */
idh120      number(15,3),            /*df2(墨迹污染)                          */
idh121      number(15,3),            /*df3(焊垫污染)                          */
idh122      number(15,3),            /*df4(刮  伤)                            */
idh123      number(15,3),            /*df5(崩  裂)                            */
idh124      number(15,3),            /*df6(硅粉污染)                          */
idh125      number(15,3),            /*df7(护层不良)                          */
idh126      number(15,3),            /*df8(外物污染)                          */
idh127      number(15,3),            /*df9(破 片)                             */
idh128      number(15,3),            /*df10(暗  裂)                           */
idh129      number(15,3),            /*df11(焊垫氧化)                         */
idh130      number(15,3),            /*df12(焊垫腐蚀)                         */
idh131      number(15,3),            /*df13(切割偏移)                         */
idh132      number(15,3),            /*df14(水  痕)                           */
idh133      number(15,3),            /*df15(液  滴)                           */
idh134      number(15,3),            /*df16(短  少)                           */
idh135      number(15,3),            /*df17(溢  出)                           */
idh136      number(15,3),            /*df18(探针突出)                         */
idh137      number(15,3),            /*df19(缺  角)                           */
idh138      number(15,3),            /*df20(其他1)                            */
idh139      number(15,3),            /*df21(其他2)                            */
idh140      number(15,3),            /*df22(其他3)                            */
idh141      number(15,3),            /*df23(其他4)                            */
idh142      number(15,3),            /*df24(其他5)                            */
idh143      number(15,3),            /*不良品总数                             */
idh144      varchar2(1),             /*转档否                                 */
idhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
idh145      varchar2(10),            /*仓库                                   */
idh146      varchar2(10)             /*库位                                   */
);

alter table idh_file add  constraint idh_pk primary key  (idh001,idh0011) enable validate;
grant select on idh_file to tiptopgp;
grant update on idh_file to tiptopgp;
grant delete on idh_file to tiptopgp;
grant insert on idh_file to tiptopgp;
grant index on idh_file to public;
grant select on idh_file to ods;
