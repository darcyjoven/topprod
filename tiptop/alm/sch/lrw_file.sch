/*
================================================================================
檔案代號:lrw_file
檔案名稱:换卡维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrw_file
(
lrw01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lrw02       varchar2(20),            /*会员编号                               */
lrw03       varchar2(30),            /*原卡卡号                               */
lrw04       varchar2(20),            /*卡种编号                               */
lrw05       varchar2(1) DEFAULT ' ' NOT NULL, /*原卡状态*/
lrw06       number(20,2) DEFAULT '0' NOT NULL, /*原卡内余额*/
lrw07       number(20) DEFAULT '0' NOT NULL, /*原卡内积分*/
lrw08       date,                    /*原卡有效期                             */
lrw09       varchar2(30),            /*新卡卡号                               */
lrw10       varchar2(20),            /*新卡卡种                               */
lrw11       number(20,2) DEFAULT '0' NOT NULL, /*新卡卡内金额*/
lrw12       number(20) DEFAULT '0' NOT NULL, /*新卡卡内积分*/
lrw13       date,                    /*新卡有效期                             */
lrw14       varchar2(10),            /*换卡原因编号                           */
lrw15       date,                    /*单据日期                               */
lrw16       varchar2(1) DEFAULT 'N' NOT NULL, /*确认码*/
lrw17       varchar2(10),            /*审核人                                 */
lrw18       date,                    /*审核日期                               */
lrw19       varchar2(50),            /*备注                                   */
lrw20       number(6,2),             /*原卡储值折扣率                         */
lrw21       varchar2(10),            /*原会员等级                             */
lrw22       varchar2(10),            /*现会员等级                             */
lrwacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
lrwcrat     date,                    /*资料创建日                             */
lrwdate     date,                    /*最近更改日                             */
lrwgrup     varchar2(10),            /*资料所有群                             */
lrwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrwmodu     varchar2(10),            /*资料更改者                             */
lrworig     varchar2(10),            /*资料建立部门                           */
lrworiu     varchar2(10),            /*资料建立者                             */
lrwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrwuser     varchar2(10),            /*资料所有者                             */
lrw23       number(20,2) DEFAULT '0' NOT NULL, /*换卡手续费*/
lrw24       varchar2(20),            /*对应出货单号                           */
lrw25       varchar2(20)             /*POS单号                                */
);

alter table lrw_file add  constraint lrw_pk primary key  (lrw01) enable validate;
grant select on lrw_file to tiptopgp;
grant update on lrw_file to tiptopgp;
grant delete on lrw_file to tiptopgp;
grant insert on lrw_file to tiptopgp;
grant index on lrw_file to public;
grant select on lrw_file to ods;
