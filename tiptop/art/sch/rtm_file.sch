/*
================================================================================
檔案代號:rtm_file
檔案名稱:自定价调整单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtm_file
(
rtm01       varchar2(20) DEFAULT ' ' NOT NULL, /*调整单单号*/
rtm02       varchar2(1),             /*生效方式 1-立即变更2-指定日            */
                                     /*Effective Method 1-Change Now 2. Assign a Date*/
rtm03       date,                    /*生效日期                               */
rtm04       number(5,2),             /*标准售价预调价比例                     */
rtm05       number(5,2),             /*标准会员价预调价比例                   */
rtm06       number(5,2),             /*标准最低价预调价比例                   */
rtm07       varchar2(255),           /*备注                                   */
rtm900      varchar2(1),             /*状况码                                 */
rtmacti     varchar2(1),             /*资料有效码                             */
rtmcond     date,                    /*审核日期                               */
rtmconf     varchar2(1),             /*确认码                                 */
rtmconu     varchar2(10),            /*审核人员                               */
rtmcrat     date,                    /*资料创建日                             */
rtmdate     date,                    /*最近更改者                             */
rtmdays     number(5),               /*签核完成天数                           */
rtmgrup     varchar2(10),            /*资料所有部门                           */
rtmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtmmksg     varchar2(1),             /*是否签核                               */
rtmmodu     varchar2(10),            /*资料更改者                             */
rtmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rtmprit     number(5),               /*签核优先等级                           */
rtmsign     varchar2(4),             /*签核等级                               */
rtmsmax     number(5),               /*应签核顺序                             */
rtmsseq     number(5),               /*已签核顺序                             */
rtmuser     varchar2(10),            /*资料所有者                             */
rtmoriu     varchar2(10),            /*资料建立者                             */
rtmorig     varchar2(10)             /*资料建立部门                           */
);

alter table rtm_file add  constraint rtm_pk primary key  (rtm01) enable validate;
grant select on rtm_file to tiptopgp;
grant update on rtm_file to tiptopgp;
grant delete on rtm_file to tiptopgp;
grant insert on rtm_file to tiptopgp;
grant index on rtm_file to public;
grant select on rtm_file to ods;
