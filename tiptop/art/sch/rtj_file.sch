/*
================================================================================
檔案代號:rtj_file
檔案名稱:策略变更单商品单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtj_file
(
rtj01       varchar2(20) NOT NULL,   /*策略变更单号                           */
rtj02       varchar2(1) DEFAULT ' ' NOT NULL, /*变更类型*/
                                     /*Changed Type 1:Merchandising Strategy 2:Price Strategy*/
rtj03       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtj04       varchar2(40),            /*产品编号                               */
rtj05       varchar2(1),             /*No Use                                 */
                                     /*Changed Type 1:Add 2:Update            */
rtj06       varchar2(1),             /*是否可采                               */
rtj07       varchar2(1),             /*是否可售                               */
rtj08       varchar2(1),             /*是否可退                               */
rtj09       varchar2(4),             /*计价单位                               */
rtj10       number(20,6),            /*原标准售价                             */
rtj11       number(20,6),            /*原标准会员价                           */
rtj12       number(20,6),            /*原标准最低价                           */
rtj13       number(5,2),             /*标准售价调价比例                       */
rtj14       number(5,2),             /*标准会员价调价比例                     */
rtj15       number(5,2),             /*标准最低价调价比例                     */
rtj16       number(20,6),            /*新标准售价                             */
rtj17       number(20,6),            /*新标准会员价                           */
rtj18       number(20,6),            /*新标准最低价                           */
rtj19       varchar2(1),             /*允许自定价                             */
rtj20       varchar2(1),             /*有效否                                 */
rtjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rtj21       varchar2(4),             /*税种                                   */
rtj22       varchar2(1) DEFAULT '2' NOT NULL, /*进/销项*/
rtj23       varchar2(1) DEFAULT 'N' NOT NULL, /*開價否*/
rtj24       varchar2(20),            /*策略编号                               */
rtj25       number(20,6)             /*最高退价                               */
);

create        index rtj_02 on rtj_file (rtj04,rtj09);
alter table rtj_file add  constraint rtj_pk primary key  (rtj01,rtj02,rtj03) enable validate;
grant select on rtj_file to tiptopgp;
grant update on rtj_file to tiptopgp;
grant delete on rtj_file to tiptopgp;
grant insert on rtj_file to tiptopgp;
grant index on rtj_file to public;
grant select on rtj_file to ods;
