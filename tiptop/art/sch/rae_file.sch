/*
================================================================================
檔案代號:rae_file
檔案名稱:组合促销单头表
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rae_file
(
rae01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rae02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rae03       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rae04       date,                    /*No Use                                 */
rae05       date,                    /*No Use                                 */
rae06       varchar2(8),             /*No Use                                 */
rae07       varchar2(8),             /*No Use                                 */
rae08       varchar2(1),             /*周期否                                 */
rae09       varchar2(1),             /*限定否                                 */
rae10       varchar2(1) DEFAULT ' ' NOT NULL, /*促销方式  1:特价 2:折扣 3:折让*/
rae11       varchar2(1) DEFAULT ' ' NOT NULL, /*是否会员专享*/
rae12       varchar2(1) DEFAULT ' ' NOT NULL, /*会员促销方式*/
rae13       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参与收券*/
rae14       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加积分*/
rae15       number(20,6) DEFAULT '0' NOT NULL, /*特卖价*/
rae16       number(5,2),             /*折扣率%                                */
rae17       number(20,6) DEFAULT '0' NOT NULL, /*折让额*/
rae18       number(20,6) DEFAULT '0' NOT NULL, /*会员特卖价*/
rae19       number(5,2),             /*会员折扣率%                            */
rae20       number(20,6) DEFAULT '0' NOT NULL, /*会员折让额*/
rae21       number(5) DEFAULT '0',   /*组合总量                               */
rae22       varchar2(255),           /*备注                                   */
rae23       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加满额促销*/
rae24       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加返券促销*/
rae25       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加联盟卡折扣*/
rae26       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加会员卡折扣*/
rae27       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参与换赠*/
rae28       varchar2(1) DEFAULT ' ' NOT NULL, /*促销实现方式1.交易中2.交易后*/
rae29       varchar2(1) DEFAULT ' ' NOT NULL, /*换赠方式 1.超量 2.倍量*/
rae30       varchar2(1) DEFAULT ' ' NOT NULL, /*换赠类型 1.单选 2.多选*/
rae31       number(5),               /*最多可选品种个数                       */
rae900      varchar2(1) DEFAULT ' ' NOT NULL, /*狀況碼0.開立1.已核准9.作廢R.  */
raeacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raecond     date,                    /*审核日期                               */
raeconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
raeconu     varchar2(10),            /*审核人员                               */
raecrat     date,                    /*资料创建日                             */
raedate     date,                    /*最近更改日                             */
raedays     number(5),               /*签核完成天数                           */
raegrup     varchar2(10),            /*资料所有部门                           */
raelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
raemksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
raemodu     varchar2(10),            /*最近更改人                             */
raeorig     varchar2(10),            /*资料建立部门                           */
raeoriu     varchar2(10),            /*资料建立者                             */
raeplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
raepos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
raeprit     number(5),               /*签核优先等级                           */
raesign     varchar2(4),             /*签核等级                               */
raesmax     number(5),               /*应签核顺序                             */
raesseq     number(5),               /*已签核顺序                             */
raeuser     varchar2(10),            /*资料所有者                             */
raecont     varchar2(8),             /*审核时间                               */
rae901      date,                    /*发布日期                               */
rae902      varchar2(8)              /*發佈時間                               */
);

alter table rae_file add  constraint rae_pk primary key  (rae01,rae02,raeplant) enable validate;
grant select on rae_file to tiptopgp;
grant update on rae_file to tiptopgp;
grant delete on rae_file to tiptopgp;
grant insert on rae_file to tiptopgp;
grant index on rae_file to public;
grant select on rae_file to ods;
