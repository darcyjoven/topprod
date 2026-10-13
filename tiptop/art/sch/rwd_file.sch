/*
================================================================================
檔案代號:rwd_file
檔案名稱:品类特价单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwd_file
(
rwd01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rwd02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwd03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price*/
rwd04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwd05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwd06       varchar2(40),            /*品类代码                               */
rwd07       varchar2(1),             /*特价方式                               */
                                     /*Price Preference Method 1:Promotion 2:Discount*/
rwd08       number(5,2),             /*折扣%                                  */
rwd09       number(5,2),             /*会员折扣%                              */
rwd10       number(20,6),            /*折价                                   */
rwd11       number(20,6),            /*会员折价                               */
rwd12       varchar2(1),             /*依会员等级促销                         */
rwd13       date,                    /*促销开始日期                           */
rwd14       date,                    /*促销结束日期                           */
rwd15       varchar2(8),             /*促销开始时间                           */
rwd16       varchar2(8),             /*促销结束时间                           */
rwd17       varchar2(255),           /*备注                                   */
rwd18       varchar2(1),             /*有效否                                 */
rwdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwdplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rwdpos      varchar2(1)              /*已传POS否                              */
);

alter table rwd_file add  constraint rwd_pk primary key  (rwd01,rwd02,rwd03,rwd04,rwd05,rwdplant) enable validate;
grant select on rwd_file to tiptopgp;
grant update on rwd_file to tiptopgp;
grant delete on rwd_file to tiptopgp;
grant insert on rwd_file to tiptopgp;
grant index on rwd_file to public;
grant select on rwd_file to ods;
