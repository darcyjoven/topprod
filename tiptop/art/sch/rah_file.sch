/*
================================================================================
檔案代號:rah_file
檔案名稱:满额促销单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rah_file
(
rah01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rah02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rah03       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rah04       date,                    /*No Use                                 */
rah05       date,                    /*No Use                                 */
rah06       varchar2(8),             /*No Use                                 */
rah07       varchar2(8),             /*No Use                                 */
rah08       varchar2(1) DEFAULT ' ' NOT NULL, /*折让基数*/
rah09       varchar2(1) DEFAULT ' ' NOT NULL, /*限定否*/
rah10       varchar2(1) DEFAULT ' ' NOT NULL, /*促銷方式*/
rah11       varchar2(1) DEFAULT ' ' NOT NULL, /*参与方式*/
                                     /*1.整单促销 2.范围促销                  */
rah12       varchar2(1) DEFAULT ' ' NOT NULL, /*分段計算否*/
rah13       varchar2(1) DEFAULT ' ' NOT NULL, /*是否会员专享*/
rah14       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参与收券*/
rah15       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参与积分*/
rah16       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加返券促销*/
rah17       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加联盟卡折扣*/
rah18       varchar2(1) DEFAULT ' ' NOT NULL, /*是否参加会员卡折扣*/
rah19       varchar2(1) DEFAULT ' ' NOT NULL, /*是否參與換贈*/
rah20       varchar2(1) DEFAULT ' ' NOT NULL, /*促銷實現方式*/
rah21       varchar2(1) DEFAULT ' ' NOT NULL, /*換贈方式*/
rah22       varchar2(1) DEFAULT ' ' NOT NULL, /*換贈類型*/
rah23       number(5),               /*最多可选品种个数                       */
rah24       varchar2(255),           /*备注                                   */
rah900      varchar2(1) DEFAULT '0' NOT NULL, /*状况码*/
rahacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rahcond     date,                    /*审核日期                               */
rahconf     varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
rahconu     varchar2(10),            /*审核人员                               */
rahcrat     date,                    /*资料创建日                             */
rahdate     date,                    /*最近更改日                             */
rahdays     number(5),               /*签核完成天数                           */
rahgrup     varchar2(10),            /*资料所有部门                           */
rahlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rahmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
rahmodu     varchar2(10),            /*资料更改者                             */
rahorig     varchar2(10),            /*资料建立部门                           */
rahoriu     varchar2(10),            /*资料建立者                             */
rahplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rahpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
rahprit     number(5),               /*签核优先等级                           */
rahsign     varchar2(4),             /*签核等级                               */
rahsmax     number(5),               /*应签核顺序                             */
rahsseq     number(5),               /*已签核顺序                             */
rahuser     varchar2(10),            /*资料所有者                             */
rahcont     varchar2(8),             /*审核时间                               */
rah25       varchar2(1) DEFAULT '1' NOT NULL, /*条件规则1.满额2.满量*/
rah901      date,                    /*发布日期                               */
rah902      varchar2(8)              /*發佈時間                               */
);

alter table rah_file add  constraint rah_pk primary key  (rah01,rah02,rahplant) enable validate;
grant select on rah_file to tiptopgp;
grant update on rah_file to tiptopgp;
grant delete on rah_file to tiptopgp;
grant insert on rah_file to tiptopgp;
grant index on rah_file to public;
grant select on rah_file to ods;
