/*
================================================================================
檔案代號:rbh_file
檔案名稱:满额促销变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbh_file
(
rbh01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbh02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbh03       number(5) DEFAULT '0' NOT NULL, /*异动序号*/
rbh04       date,                    /*No Use                                 */
rbh04t      date,                    /*No Use                                 */
rbh05       date,                    /*No Use                                 */
rbh05t      date,                    /*No Use                                 */
rbh06       varchar2(8),             /*No Use                                 */
rbh06t      varchar2(8),             /*No Use                                 */
rbh07       varchar2(8),             /*No Use                                 */
rbh07t      varchar2(8),             /*No Use                                 */
rbh08       varchar2(1),             /*变更前周期否                           */
rbh08t      varchar2(1),             /*变更后周期否                           */
rbh09       varchar2(1),             /*变更前限定否                           */
rbh09t      varchar2(8),             /*变更后限定否                           */
rbh10       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前促销方式:2.折扣3.原价  */
rbh10t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后促销方式:2.折扣3.原价  */
rbh11       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前参与方式:1.整单促销,2. */
rbh11t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后参与方式:1.整单促销,2. */
rbh12       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前分段计算否*/
rbh12t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后分段计算否*/
rbh13       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否会员专享*/
rbh13t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否会员专享*/
rbh14       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与收劵*/
rbh14t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与收劵*/
rbh15       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与积分*/
rbh15t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与积分*/
rbh16       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与返劵促销*/
rbh16t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与返劵促销*/
rbh17       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与联盟卡折扣*/
rbh17t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与联盟卡折扣*/
rbh18       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与会员卡折扣*/
rbh18t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与会员卡折扣*/
rbh19       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与换增*/
rbh19t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与换增*/
rbh20       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前促销实现方式:1.交易中,*/
rbh20t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后促销实现方式:1.交易中,*/
rbh21       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前换增方式:1.超量,2.倍量*/
rbh21t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后换增方式:1.超量,2.倍量*/
rbh22       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前换增类型:1.单选,2.多选*/
rbh22t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后换增类型:1.单选,2.多选*/
rbh23       number(5),               /*变更前最多可选数量                     */
rbh23t      number(5),               /*变更后最多可选数量                     */
rbh24       varchar2(255),           /*备注                                   */
rbh25       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前添加规则:1.满额,2.满量*/
rbh25t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后添加规则:1.满额,2.满量*/
rbh26       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rbh900      varchar2(1) DEFAULT '0' NOT NULL, /*状况码:0:开立,1:已核准,9:作废,*/
rbhacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rbhcond     date,                    /*审核日期                               */
rbhconf     varchar2(1) DEFAULT 'N', /*审核码Y-已审核N-未审核X-已作           */
rbhcont     varchar2(8),             /*审核时间                               */
rbhconu     varchar2(10),            /*审核人员                               */
rbhcrat     date,                    /*资料创建日                             */
rbhdate     date,                    /*最近更改日                             */
rbhdays     number(5),               /*签核完成天数                           */
rbhgrup     varchar2(10),            /*资料所有部门                           */
rbhlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbhmksg     varchar2(1) DEFAULT 'N' NOT NULL, /*是否签核*/
rbhmodu     varchar2(10),            /*最近更改日                             */
rbhorig     varchar2(10),            /*资料建立部门                           */
rbhoriu     varchar2(10),            /*资料建立者                             */
rbhplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rbhprit     number(5),               /*签核优先等级                           */
rbhsign     varchar2(4),             /*签核等级                               */
rbhsmax     number(5),               /*应签核顺序                             */
rbhsseq     number(5),               /*已签核顺序                             */
rbhuser     varchar2(10)             /*资料所有者                             */
);

alter table rbh_file add  constraint rbh_pk primary key  (rbh01,rbh02,rbh03,rbhplant) enable validate;
grant select on rbh_file to tiptopgp;
grant update on rbh_file to tiptopgp;
grant delete on rbh_file to tiptopgp;
grant insert on rbh_file to tiptopgp;
grant index on rbh_file to public;
grant select on rbh_file to ods;
