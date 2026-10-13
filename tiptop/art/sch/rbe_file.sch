/*
================================================================================
檔案代號:rbe_file
檔案名稱:组合促销变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbe_file
(
rbe01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbe02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbe03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbe04       date,                    /*No Use                                 */
rbe04t      date,                    /*No Use                                 */
rbe05       date,                    /*No Use                                 */
rbe05t      date,                    /*No Use                                 */
rbe06       varchar2(8),             /*No Use                                 */
rbe06t      varchar2(8),             /*No Use                                 */
rbe07       varchar2(8),             /*No Use                                 */
rbe07t      varchar2(8),             /*No Use                                 */
rbe08       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前周期否*/
rbe08t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后周期否*/
rbe09       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前限定否*/
rbe09t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后限定否*/
rbe10       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前促销方式*/
rbe10t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后促销方式*/
rbe11       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否会员专享*/
rbe11t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否会员专享*/
rbe12       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前会员促销方式*/
rbe12t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后会员促销方式*/
rbe13       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与收劵*/
rbe13t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与收劵*/
rbe14       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与积分*/
rbe14t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与积分*/
rbe15       number(20,6) DEFAULT '0' NOT NULL, /*变更前特卖价*/
rbe15t      number(20,6) DEFAULT '0' NOT NULL, /*变更后特卖价*/
rbe16       number(5,2),             /*變更前折扣率                           */
rbe16t      number(5,2),             /*變更后折扣率                           */
rbe17       number(20,6) DEFAULT '0' NOT NULL, /*变更前折让价*/
rbe17t      number(20,6) DEFAULT '0' NOT NULL, /*变更后折让价*/
rbe18       number(20,6) DEFAULT '0' NOT NULL, /*变更前会员特卖价*/
rbe18t      number(20,6) DEFAULT '0' NOT NULL, /*变更后会员特卖价*/
rbe19       number(5,2),             /*變更前會員折扣率                       */
rbe19t      number(5,2),             /*變更后會員折扣率                       */
rbe20       number(20,6) DEFAULT '0' NOT NULL, /*变更前会员折让额*/
rbe20t      number(20,6) DEFAULT '0' NOT NULL, /*变更后会员折让额*/
rbe21       number(5),               /*变更前组合数量                         */
rbe21t      number(5),               /*变更后组合数量                         */
rbe22       varchar2(255),           /*备注                                   */
rbe23       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参加满额促销*/
rbe23t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参加满额促销*/
rbe24       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参加返劵促销*/
rbe24t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参加返劵促销*/
rbe25       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参加联盟卡促销*/
rbe25t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参加联盟卡促销*/
rbe26       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参加会员卡折扣*/
rbe26t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参加会员卡折扣*/
rbe27       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前是否参与换增*/
rbe27t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后是否参与换增*/
rbe28       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前促销实现方式*/
rbe28t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后促销实现方式*/
rbe29       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前换增方式*/
rbe29t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后换增方式*/
rbe30       varchar2(1) DEFAULT ' ' NOT NULL, /*变更前换增类型*/
rbe30t      varchar2(1) DEFAULT ' ' NOT NULL, /*变更后换增类型*/
rbe31       number(5),               /*变更前最多可选数量                     */
rbe31t      number(5),               /*变更后最多可选数量                     */
rbe32       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rbe900      varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
rbeacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rbecond     date,                    /*审核日期                               */
rbeconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核码*/
rbeconu     varchar2(10),            /*审核人员                               */
rbecrat     date,                    /*资料创建日                             */
rbedate     date,                    /*资料更改日                             */
rbedays     number(5),               /*签核完成天数                           */
rbegrup     varchar2(10),            /*资料所有部门                           */
rbelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbemksg     varchar2(1) DEFAULT 'N' NOT NULL, /*是否签核*/
rbemodu     varchar2(10),            /*资料更改者                             */
rbeorig     varchar2(10),            /*资料建立部门                           */
rbeoriu     varchar2(10),            /*资料建立者                             */
rbeplant    varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rbeprit     number(5),               /*签核优先等级                           */
rbesign     varchar2(4),             /*签核等级                               */
rbesmax     number(5),               /*应签核顺序                             */
rbesseq     number(5),               /*已签核顺序                             */
rbeuser     varchar2(10)             /*资料所有者                             */
);

alter table rbe_file add  constraint rbe_pk primary key  (rbe01,rbe02,rbe03,rbeplant) enable validate;
grant select on rbe_file to tiptopgp;
grant update on rbe_file to tiptopgp;
grant delete on rbe_file to tiptopgp;
grant insert on rbe_file to tiptopgp;
grant index on rbe_file to public;
grant select on rbe_file to ods;
