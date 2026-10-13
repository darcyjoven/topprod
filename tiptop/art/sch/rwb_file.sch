/*
================================================================================
檔案代號:rwb_file
檔案名稱:特价促销单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwb_file
(
rwb01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
rwb02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwb03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price*/
rwb04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwb05       varchar2(40),            /*促销名称                               */
rwb06       date,                    /*促销开始日期                           */
rwb07       date,                    /*促销结束日期                           */
rwb08       varchar2(8),             /*促销开始时间                           */
rwb09       varchar2(8),             /*促销结束时间                           */
rwb10       varchar2(1),             /*特价方式                               */
                                     /*Price Preference Method 1:Promotion 2:Discount 3:Discount Amt*/
rwb11       number(5,2),             /*折扣率%                                */
rwb12       number(20,6),            /*折价额                                 */
rwb13       varchar2(1),             /*全面特价                               */
rwb14       varchar2(1),             /*限定方式                               */
                                     /*Limit Method 1:Include 2:Non-Include 3:Non-Limit*/
rwb15       varchar2(1),             /*限定类别                               */
                                     /*Limit Category 1:By Goods 2:By Brand Class.*/
rwb16       varchar2(1),             /*是否参加积分                           */
rwb17       varchar2(1),             /*是否参加满额计算                       */
rwb18       varchar2(255),           /*备注                                   */
rwb900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rwbacti     varchar2(1),             /*资料有效码                             */
rwbcond     date,                    /*审核日期                               */
rwbconf     varchar2(1),             /*审核码                                 */
rwbconu     varchar2(10),            /*审核人员                               */
rwbcrat     date,                    /*资料创建日                             */
rwbdate     date,                    /*最近更改日                             */
rwbdays     number(5),               /*签核完成天数                           */
rwbgrup     varchar2(10),            /*资料所有部门                           */
rwblegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwbmksg     varchar2(1),             /*是否签核                               */
rwbmodu     varchar2(10),            /*资料更改者                             */
rwbplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rwbprit     number(5),               /*签核优先等级                           */
rwbsign     varchar2(4),             /*签核等级                               */
rwbsmax     number(5),               /*应签核顺序                             */
rwbsseq     number(5),               /*已签核顺序                             */
rwbuser     varchar2(10),            /*资料所有者                             */
rwboriu     varchar2(10),            /*资料建立者                             */
rwborig     varchar2(10)             /*资料建立部门                           */
);

alter table rwb_file add  constraint rwb_pk primary key  (rwb01,rwb02,rwb03,rwb04,rwbplant) enable validate;
grant select on rwb_file to tiptopgp;
grant update on rwb_file to tiptopgp;
grant delete on rwb_file to tiptopgp;
grant insert on rwb_file to tiptopgp;
grant index on rwb_file to public;
grant select on rwb_file to ods;
