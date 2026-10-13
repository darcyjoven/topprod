/*
================================================================================
檔案代號:giu_file
檔案名稱:多地区会计科目名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giu_file
(
giu00       varchar2(1) NOT NULL,    /*地区                                   */
giu01       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*Serial number of account               */
giu02       varchar2(255),           /*科目名称                               */
                                     /*Account name                           */
giu03       varchar2(1),             /*科目性质                               */
                                     /*Account nature  (2. Account  4.Carry down)*/
giu04       varchar2(1),             /*资产损益别                             */
                                     /*The assets increase and decrease leaving  (1. Asset-liabilities / 2. The increase and decrease)*/
giu05       varchar2(1),             /*本科目是否作部门明细管理               */
                                     /*Whether this account functions as department"s detail to manage (Y/N )*/
giu06       varchar2(1),             /*正常余额类型                           */
                                     /*Normal balance type attitude  (1. Borrow to the I / 2. Borrow me)*/
giu07       varchar2(1),             /*统制明细别                             */
                                     /*Control the detail to leave            */
                                     /*Control the detail to leave            */
                                     /*(1.Control accounts 2. Detail account 3. Independent account)*/
giu08       varchar2(24),            /*所属统制帐户科目                       */
                                     /*Control account of accounts affiliatedly*/
giu09       varchar2(1),             /*是否为货币性科目                       */
                                     /*Whether it is currency account (Y/N )  */
giu10       varchar2(10),            /*No Use                                 */
giu11       varchar2(4),             /*No Use                                 */
giu12       varchar2(4),             /*计数单位                               */
                                     /*Count in the unit                      */
giu13       varchar2(255),           /*额外名称                               */
                                     /*Extra name                             */
giu14       varchar2(255),           /*备注                                   */
                                     /*Remarks                                */
giu15       varchar2(10),            /*核算项-1名称                           */
                                     /*1 name of transaction code             */
giu16       varchar2(10),            /*核算项-2名称                           */
                                     /*Code - 2 names of transaction          */
giu17       varchar2(10),            /*核算项-3名称                           */
                                     /*Code - 3 names of transaction          */
giu18       varchar2(10),            /*核算项-4名称                           */
                                     /*Code - 4 names of transaction          */
giu151      varchar2(1),             /*核算项-1控制方式                       */
                                     /*Transaction is flag - a control method */
                                     /*Transaction is flag - a control method */
                                     /*NULL: Do not input                     */
                                     /*1: Can input , but the blank           */
                                     /*2.Must input , does not need to check  */
                                     /*3.Must input , must check              */
giu161      varchar2(1),             /*核算项-2控制方式                       */
                                     /*Transaction is flag - 2 control methods*/
giu171      varchar2(1),             /*核算项-3控制方式                       */
                                     /*Transaction is flag - 3 control methods*/
giu181      varchar2(1),             /*核算项-4控制方式                       */
                                     /*Transaction is flag - 4 control methods*/
giu19       number(5),               /*财务比率分析类型                       */
                                     /*Analyse the classification in financial rate (1-27)*/
giu20       varchar2(1),             /*细项立冲否                             */
                                     /*Thin one sets up and prints flag (Y/N) (99-05-21 add)*/
giu21       varchar2(1),             /*线上预算控制                           */
                                     /*Whether make the on-line budget control (Y/N )*/
giu221      varchar2(5),             /*费用固定变动别                         */
                                     /*The regular change of the expenses is left (F/V)RegularChange*/
giu222      varchar2(5),             /*凭证项次异动别                         */
                                     /*Subpoena each"s unusual fluctuation is left (1: The debit sets up accounts  2: The credit side sets up accounts)*/
giu223      varchar2(10),            /*分类码一                               */
                                     /*Classify code one                      */
giu224      varchar2(10),            /*分类码二                               */
                                     /*Classify code two                      */
giu225      varchar2(10),            /*分类码三                               */
                                     /*Classify code three                    */
giu226      varchar2(10),            /*分类码四                               */
                                     /*Classify code four                     */
giu23       varchar2(1),             /*作项目管理                             */
                                     /*Whether make special project to manage (Y/N )*/
giu24       number(5),               /*科目层级                               */
                                     /*Level for continent edition of account */
giu25       varchar2(1),             /*No Use                                 */
giu26       varchar2(1),             /*No Use                                 */
giuacti     varchar2(1),             /*资料有效码                             */
giuuser     varchar2(10),            /*资料所有者                             */
giugrup     varchar2(10),            /*资料所有群                             */
giumodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Updated by                        */
giudate     date,                    /*最近更改日                             */
giu31       varchar2(10),            /*核算项-5名称                           */
giu311      varchar2(1),             /*核算项-5控制方式                       */
giu32       varchar2(10),            /*核算项-6名称                           */
giu321      varchar2(1),             /*核算项-6控制方式                       */
giu33       varchar2(10),            /*核算项-7名称                           */
giu331      varchar2(1),             /*核算项-7控制方式                       */
giu34       varchar2(10),            /*核算项-8名称                           */
giu341      varchar2(1),             /*核算项-8控制方式                       */
giu35       varchar2(10),            /*核算项-9名称                           */
giu351      varchar2(1),             /*核算项-9控制方式                       */
giu36       varchar2(10),            /*核算项-10名称                          */
giu361      varchar2(1),             /*核算项-10控制方式                      */
giu37       varchar2(10),            /*核算项-关系人                          */
giu371      varchar2(1),             /*核算项-关系人控制方式                  */
giu38       varchar2(1),             /*是否为内部管理科目                     */
giu39       varchar2(10),            /*资料来源                               */
giu40       number(10),              /*抛转次数                               */
giuoriu     varchar2(10),            /*资料建立者                             */
giuorig     varchar2(10),            /*资料建立部门                           */
giu42       varchar2(1) DEFAULT 'N' NOT NULL /*按餘額類型產生分錄*/
);

create        index giu_02 on giu_file (giu08);
alter table giu_file add  constraint giu_pk primary key  (giu00,giu01) enable validate;
grant select on giu_file to tiptopgp;
grant update on giu_file to tiptopgp;
grant delete on giu_file to tiptopgp;
grant insert on giu_file to tiptopgp;
grant index on giu_file to public;
grant select on giu_file to ods;
