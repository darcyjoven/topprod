/*
================================================================================
檔案代號:rwi_file
檔案名稱:满额促销单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwi_file
(
rwi01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
rwi02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwi03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price 6.Full Amount Promotion 9.Rebate Promotion*/
rwi04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwi05       varchar2(40),            /*促销名称                               */
rwi06       date,                    /*促销开始日期                           */
rwi07       date,                    /*促销结束日期                           */
rwi08       varchar2(8),             /*促销开始时间                           */
rwi09       varchar2(8),             /*促销结束时间                           */
rwi10       varchar2(1) DEFAULT ' ' NOT NULL, /*特价方式*/
                                     /*Price Preference Method                */
                                     /*1:Promotion 2:Discount 3:Discount Amt 4: Premium 5:Price-Added*/
rwi11       number(20,6) DEFAULT '0' NOT NULL, /*满额金额*/
rwi12       varchar2(1) DEFAULT 'N' NOT NULL, /*依满额金额倍数计算赠品量*/
rwi13       varchar2(1) DEFAULT 'N' NOT NULL, /*限定方式*/
                                     /*Limit Method 1:Include 2:Non-Include 3:Non-Limit*/
rwi14       varchar2(1) DEFAULT ' ' NOT NULL, /*限定类别*/
                                     /*Limit Category 1:By Goods 2:By Brand Class.*/
rwi15       varchar2(1) DEFAULT 'N' NOT NULL, /*依会员等级促销*/
rwi16       varchar2(1) DEFAULT 'N' NOT NULL, /*是否参加积分*/
rwi17       varchar2(255),           /*备注                                   */
rwi900      varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rwiacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rwicond     date,                    /*审核时间                               */
rwiconf     varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
rwiconu     varchar2(10),            /*审核人员                               */
rwicrat     date,                    /*资料创建日                             */
rwidate     date,                    /*最近更改日                             */
rwidays     number(5) DEFAULT '0' NOT NULL, /*签核完成天数*/
rwigrup     varchar2(10),            /*资料所有部门                           */
rwilegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwimksg     varchar2(1) DEFAULT 'Y' NOT NULL, /*是否签核*/
rwimodu     varchar2(10),            /*资料更改者                             */
rwiplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rwipos      varchar2(1) DEFAULT 'N' NOT NULL, /*已传POS否*/
rwiprit     number(5) DEFAULT '0' NOT NULL, /*签核优先等级*/
rwisign     varchar2(4),             /*签核等级                               */
rwismax     number(5) DEFAULT '0' NOT NULL, /*应签核顺序*/
rwisseq     number(5) DEFAULT '0' NOT NULL, /*已签核顺序*/
rwiuser     varchar2(10),            /*资料所有者                             */
rwi18       varchar2(1) DEFAULT ' ' NOT NULL, /*换赠限定*/
                                     /*换赠限定 1.单选 2.多选                 */
rwi19       varchar2(1) DEFAULT ' ' NOT NULL, /*促銷實現方式*/
                                     /*Promotion Realizing Method 1. During Trading 2. After Trading*/
rwiorig     varchar2(10),            /*资料建立部门                           */
rwioriu     varchar2(10)             /*资料建立者                             */
);

alter table rwi_file add  constraint rwi_pk primary key  (rwi01,rwi02,rwi03,rwi04,rwiplant) enable validate;
grant select on rwi_file to tiptopgp;
grant update on rwi_file to tiptopgp;
grant delete on rwi_file to tiptopgp;
grant insert on rwi_file to tiptopgp;
grant index on rwi_file to public;
grant select on rwi_file to ods;
