/*
================================================================================
檔案代號:rwf_file
檔案名稱:组合促销单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwf_file
(
rwf01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
rwf02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwf03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type 4.Assembly Promotion    */
rwf04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwf05       varchar2(40),            /*促销名称                               */
rwf06       date,                    /*促销开始日期                           */
rwf07       date,                    /*促销结束日期                           */
rwf08       varchar2(8),             /*促销开始时间                           */
rwf09       varchar2(8),             /*促销结束时间                           */
rwf10       varchar2(1),             /*特价方式                               */
                                     /*Price Preference Method 1:Promotion 2:Discount 5:Add_Price*/
rwf11       varchar2(1),             /*组合方式                               */
                                     /*Comb Type 0:Changed 1:Fixed            */
rwf12       number(20,6),            /*特卖价                                 */
rwf13       number(20,6),            /*会员特卖价                             */
rwf14       number(5,2),             /*折扣率%                                */
rwf15       number(5,2),             /*会员折扣率%                            */
rwf16       number(15,3),            /*总数量                                 */
rwf17       varchar2(1),             /*依会员等级促销                         */
rwf18       varchar2(1),             /*是否参加积分                           */
rwf19       varchar2(1),             /*是否参加满额计算                       */
rwf20       varchar2(255),           /*备注                                   */
rwf900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rwfacti     varchar2(1),             /*资料有效码                             */
rwfcond     date,                    /*审核时间                               */
rwfconf     varchar2(1),             /*审核码                                 */
rwfconu     varchar2(10),            /*审核人员                               */
rwfcrat     date,                    /*资料创建日                             */
rwfdate     date,                    /*最近更改日                             */
rwfdays     number(5),               /*签核完成天数                           */
rwfgrup     varchar2(10),            /*资料所有部门                           */
rwflegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwfmksg     varchar2(1),             /*是否签核                               */
rwfmodu     varchar2(10),            /*资料更改者                             */
rwfplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rwfpos      varchar2(1),             /*已传POS否                              */
rwfprit     number(5),               /*签核优先等级                           */
rwfsign     varchar2(4),             /*签核等级                               */
rwfsmax     number(5),               /*应签核顺序                             */
rwfsseq     number(5),               /*已签核顺序                             */
rwfuser     varchar2(10),            /*资料所有者                             */
rwf21       varchar2(1) DEFAULT '1' NOT NULL, /*换增方式 1.倍量 2.增量*/
                                     /*Exchange/Adding Method 1. Multiples 2. Added*/
rwf22       varchar2(1) DEFAULT '1' NOT NULL, /*换增限定 1.单选 2.多选*/
                                     /*Limit of Exchange/Adding 1. Single Selection 2. Multiple Selections*/
rwf23       varchar2(1) DEFAULT '1' NOT NULL, /*促销实现方式 1.交易中  2.交易*/
                                     /*Promotion Realization 1. When Trading 2. After Trading*/
rwforiu     varchar2(10),            /*资料建立者                             */
rwforig     varchar2(10)             /*资料建立部门                           */
);

alter table rwf_file add  constraint rwf_pk primary key  (rwf01,rwf02,rwf03,rwf04,rwfplant) enable validate;
grant select on rwf_file to tiptopgp;
grant update on rwf_file to tiptopgp;
grant delete on rwf_file to tiptopgp;
grant insert on rwf_file to tiptopgp;
grant index on rwf_file to public;
grant select on rwf_file to ods;
