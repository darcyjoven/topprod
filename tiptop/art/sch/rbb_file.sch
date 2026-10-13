/*
================================================================================
檔案代號:rbb_file
檔案名稱:一般促销变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbb_file
(
rbb01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbb02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbb03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbb04       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否会员专享*/
rbb04t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否会员专享*/
rbb05       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与收劵*/
rbb05t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与收劵*/
rbb06       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与积分*/
rbb06t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与积分*/
rbb07       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与满额促销*/
rbb07t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与满额促销*/
rbb08       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与返劵促销*/
rbb08t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与返劵促销*/
rbb09t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与联盟卡折扣*/
rbb10       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与会员卡折扣*/
rbb10t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与会员卡折扣*/
rbb11       varchar2(255),           /*备注                                   */
rbb900      varchar2(1) DEFAULT ' ' NOT NULL, /*状况码:0:开立,1:已核准,9:作废,*/
rbbacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rbbcond     date,                    /*审核日期                               */
rbbconf     varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
rbbcont     varchar2(8),             /*审核时间                               */
rbbconu     varchar2(10),            /*审核人员                               */
rbbcrat     date,                    /*资料创建日                             */
rbbdate     date,                    /*最近更改日                             */
rbbdays     number(5),               /*签核完成天数                           */
rbbgrup     varchar2(10),            /*资料所有部门                           */
rbblegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbbmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
rbbmodu     varchar2(10),            /*最近更改者                             */
rbborig     varchar2(10),            /*资料创建部门                           */
rbboriu     varchar2(10),            /*资料建立者                             */
rbbplant    varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rbbprit     number(5),               /*签核优先等级                           */
rbbsign     varchar2(4),             /*签核等级                               */
rbbsmax     number(5),               /*应签核顺序                             */
rbbsseq     number(5),               /*已签核顺序                             */
rbbuser     varchar2(10),            /*资料所有者                             */
rbb09       varchar2(1) DEFAULT ' ' NOT NULL /*变更前是否参与联盟卡折扣*/
);

alter table rbb_file add  constraint rbb_pk primary key  (rbb01,rbb02,rbb03,rbbplant) enable validate;
grant select on rbb_file to tiptopgp;
grant update on rbb_file to tiptopgp;
grant delete on rbb_file to tiptopgp;
grant insert on rbb_file to tiptopgp;
grant index on rbb_file to public;
grant select on rbb_file to ods;
