/*
================================================================================
檔案代號:occa_file
檔案名稱:客户申请主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table occa_file
(
occa00      varchar2(1),             /*申请类型(I:新增 U:更改)                */
occano      varchar2(80) NOT NULL,   /*申请单号                               */
occa011     varchar2(10),            /*申请客户编号                           */
occa01      varchar2(10),            /*客户编号                               */
occa02      varchar2(40),            /*客户简称                               */
occa03      varchar2(10),            /*客户分类                               */
occa04      varchar2(10),            /*负责业务员编号                         */
occa05      varchar2(1),             /*1.永久性 2.暂时性                      */
occa06      varchar2(1),             /*性质(1.买受人 2.送货客户 3.收          */
occa07      varchar2(10),            /*收款客户编号                           */
occa08      varchar2(5),             /*惯用发票别                             */
occa09      varchar2(10),            /*送货客户编号                           */
occa10      varchar2(1),             /*是否签核                               */
occa11      varchar2(20),            /*统一发票                               */
occa12      date,                    /*创业日                                 */
occa13      number(20,6),            /*资本额                                 */
occa14      number(20,6),            /*年营业额                               */
occa15      number(15),              /*员工人数                               */
occa16      date,                    /*No Use                                 */
occa171     date,                    /*No Use                                 */
occa172     date,                    /*No Use                                 */
occa173     date,                    /*No Use                                 */
occa174     date,                    /*No Use                                 */
occa175     date,                    /*信用额度有效日期                       */
occa18      varchar2(80),            /*公司全名(1)                            */
occa19      varchar2(80),            /*公司全名(2)                            */
occa20      varchar2(10),            /*区域编号                               */
occa21      varchar2(10),            /*国家编号                               */
occa22      varchar2(10),            /*地区别                                 */
occa231     varchar2(255),           /*发票地址-1                             */
occa232     varchar2(255),           /*发票地址-2                             */
occa233     varchar2(255),           /*发票地址-3                             */
occa241     varchar2(255),           /*送货地址-1                             */
occa242     varchar2(255),           /*送货地址-2                             */
occa243     varchar2(255),           /*送货地址-3                             */
occa261     varchar2(40),            /*tel no-1                               */
occa262     varchar2(40),            /*tel no-2                               */
occa263     varchar2(40),            /*tel no-3                               */
occa271     varchar2(40),            /*fax no-1                               */
occa272     varchar2(40),            /*fax no-2                               */
occa273     varchar2(40),            /*fax no-2                               */
occa28      varchar2(40),            /*公司负责人                             */
occa29      varchar2(40),            /*业务联络人                             */
occa292     varchar2(5),             /*业务联络人分机号码                     */
occa30      varchar2(40),            /*财务联络人                             */
occa302     varchar2(5),             /*财务联络人分机号码                     */
occa31      varchar2(1),             /*客户销售库存管理否                     */
occa32      number(9,4),             /*最大折扣率                             */
occa33      varchar2(10),            /*额度客户                               */
occa34      varchar2(10),            /*集团码                                 */
occa35      varchar2(10),            /*邮递区号                               */
occa36      number(5),               /*宽限天数                               */
occa37      varchar2(1),             /*是否为关系人(y/n)                      */
occa38      varchar2(2),             /*客户月结日                             */
occa39      varchar2(2),             /*客户付款日                             */
occa39a     varchar2(2),             /*客户付款日二                           */
occa40      varchar2(1),             /*月底重评价                             */
                                     /*Regarded as Home Currency AR(Y/N)      */
                                     /*  Enter Account By Original currency ,But Regarded as Home Currency AR For Dollar-Quotation But Home Currency-Payment Customer. Not To Adjust Spread End Of Month*/
occa41      varchar2(4),             /*惯用税种                               */
occa42      varchar2(4),             /*惯用币种                               */
occa43      varchar2(10),            /*惯用销售分类                           */
occa44      varchar2(6),             /*惯用价格条件                           */
occa45      varchar2(6),             /*惯用收款条件                           */
occa46      varchar2(80),            /*惯用其它条件                           */
occa47      varchar2(10),            /*惯用交运方式                           */
occa48      varchar2(10),            /*惯用起运港口                           */
occa49      varchar2(10),            /*惯用到达港口                           */
occa50      varchar2(10),            /*惯用卸货港口                           */
occa51      varchar2(10),            /*惯用forwarder(客户编号)                */
occa52      varchar2(10),            /*惯用notify                             */
occa53      number(5),               /*惯用佣金率%                            */
occa55      varchar2(1),             /*惯用文件打印语言(0.中文 1.英           */
occa56      varchar2(1),             /*须出货通知单否                         */
occa57      varchar2(1),             /*须制作包装单否                         */
occa61      varchar2(10),            /*信用评等                               */
occa62      varchar2(1),             /*信用检查否                             */
occa63      number(20,6),            /*信用额度                               */
occa631     varchar2(4),             /*额度币种                               */
occa64      number(5),               /*信用额度容许超出比率                   */
occa701     varchar2(255),           /*备注-1                                 */
occa702     varchar2(255),           /*备注-2                                 */
occa703     varchar2(255),           /*备注-3                                 */
occa704     varchar2(255),           /*备注-4                                 */
occaacti    varchar2(1),             /*资料有效码                             */
occauser    varchar2(10),            /*资料所有者                             */
occagrup    varchar2(10),            /*资料所有部门                           */
occamodu    varchar2(10),            /*资料更改者                             */
occadate    date,                    /*最近更改日                             */
occa65      varchar2(1),             /*客户出货签收否                         */
occa1001    date,                    /*营业职照有效开始日期                   */
occa1002    date,                    /*营业职照失效开始日期                   */
occa1003    varchar2(10),            /*所属业态                               */
occa1004    varchar2(1),             /*状态码                                 */
occa1005    varchar2(10),            /*所属机构                               */
occa1006    varchar2(10),            /*所属通路                               */
occa1007    varchar2(10),            /*系统码                                 */
occa1008    varchar2(10),            /*系统区域码                             */
occa1009    varchar2(10),            /*省份/特区                              */
occa1010    varchar2(10),            /*地市级/区                              */
occa1011    varchar2(10),            /*区/县/市                               */
occa1012    varchar2(255),           /*实际公司地址                           */
occa1013    varchar2(10),            /*卖场面积                               */
occa1014    varchar2(10),            /*连锁店数                               */
occa1015    date,                    /*门店开业日                             */
occa1016    varchar2(10),            /*惯用出货仓库                           */
occa1017    varchar2(20),            /*税务登记证号                           */
occa1018    date,                    /*税务登记证有效开始期                   */
occa1019    date,                    /*税务登记证有效截止期                   */
occa1020    varchar2(10),            /*纳税人识别号                           */
occa1021    varchar2(80),            /*发票全称                               */
occa1022    varchar2(10),            /*发票客户编号                           */
occa1023    varchar2(10),            /*收款客户编号                           */
occa1024    varchar2(10),            /*业绩归属组织                           */
occa1025    varchar2(10),            /*费用归属组织                           */
occa1026    number(5),               /*对帐日                                 */
occa1027    varchar2(1),             /*是否更改订单单价                       */
occa1028    number(9,4),             /*惯用订价折扣率                         */
occaud01    varchar2(255),           /*自订字段                               */
occaud02    varchar2(40),            /*自订字段                               */
occaud03    varchar2(40),            /*自订字段                               */
occaud04    varchar2(40),            /*自订字段                               */
occaud05    varchar2(40),            /*自订字段                               */
occaud06    varchar2(40),            /*自订字段                               */
occaud07    number(15,3),            /*自订字段                               */
occaud08    number(15,3),            /*自订字段                               */
occaud09    number(15,3),            /*自订字段                               */
occaud10    number(10),              /*自订字段                               */
occaud11    number(10),              /*自订字段                               */
occaud12    number(10),              /*自订字段                               */
occaud13    date,                    /*自订字段                               */
occaud14    date,                    /*自订字段                               */
occaud15    date,                    /*自订字段                               */
occa66      varchar2(10),            /*代送商编号                             */
occa1029    varchar2(10),            /*代送商                                 */
occa67      varchar2(10),            /*惯用科目类型                           */
occaoriu    varchar2(10),            /*资料建立者                             */
occaorig    varchar2(10),            /*资料建立部门                           */
occa68      varchar2(6),             /*惯用订金收款条件代号                   */
occa69      varchar2(6)              /*惯用尾款收款条件代号                   */
);

alter table occa_file add  constraint occa_pk primary key  (occano) enable validate;
grant select on occa_file to tiptopgp;
grant update on occa_file to tiptopgp;
grant delete on occa_file to tiptopgp;
grant insert on occa_file to tiptopgp;
grant index on occa_file to public;
grant select on occa_file to ods;
