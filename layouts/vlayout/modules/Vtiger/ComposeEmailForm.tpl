{*<!--
/*********************************************************************************
** The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
*
 ********************************************************************************/
-->*}
{strip}
<div class="SendEmailFormStep2" id="composeEmailContainer">
	<div style='padding:10px 0;'>
		<h3>{vtranslate('LBL_COMPOSE_EMAIL', $MODULE)}</h3>
		<hr style='margin:5px 0;width:100%'>
	</div>
	<form class="form-horizontal" id="massEmailForm" method="post" action="index.php" enctype="multipart/form-data" name="massEmailForm">
		<input type="hidden" name="selected_ids" value='{json_encode($SELECTED_IDS)}' />
		<input type="hidden" name="excluded_ids" value='{json_encode($EXCLUDED_IDS)}' />
		<input type="hidden" name="viewname" value="{$VIEWNAME}" />
		<input type="hidden" name="module" value="{$MODULE}"/>
		<input type="hidden" name="selectedFields" value='{json_encode($SELECTED_FIELDS)}'/>
		<input type="hidden" name="mode" value="massSave" />
		<input type="hidden" name="toemailinfo" value='{json_encode($TOMAIL_INFO)}' />
		<input type="hidden" name="view" value="MassSaveAjax" />
		<input type="hidden" name="to" value='{json_encode($TO)}' />
		<input type="hidden" name="toMailNamesList" value='{json_encode($TOMAIL_NAMES_LIST)}' />
		<input type="hidden" id="flag" name="flag" value="" />
		<input type="hidden" id="maxUploadSize" value="{$MAX_UPLOAD_SIZE}" />
		<input type="hidden" id="documentIds" name="documentids" value="" />
		<input type="hidden" name="emailMode" value="{$EMAIL_MODE}" />
		{if !empty($PARENT_EMAIL_ID)}
			<input type="hidden" name="parent_id" value="{$PARENT_EMAIL_ID}" />
			<input type="hidden" name="parent_record_id" value="{$PARENT_RECORD}" />
		{/if}
		{if !empty($RECORDID)}
			<input type="hidden" name="record" value="{$RECORDID}" />
		{/if}
		<input type="hidden" name="search_key" value= "{$SEARCH_KEY}" />
		<input type="hidden" name="operator" value="{$OPERATOR}" />
		<input type="hidden" name="search_value" value="{$ALPHABET_VALUE}" />
		<input type="hidden" name="search_params" value='{json_encode($SEARCH_PARAMS)}' />
		<input type="hidden" name="cc" value='{if !empty($CC)}{json_encode($CC)}{/if}' />
		<div class="row-fluid toEmailField padding10">
			<span class="span8">
				<span class="row-fluid">
					<span class="span2">{vtranslate('LBL_TO',$MODULE)}<span class="redColor">*</span></span>
					{if !empty($TO)}
						{assign var=TO_EMAILS value=","|implode:$TO}
                    {/if}
                    
                    <span class="span9">

                    {* hide emails if more than 100   *}
                    {if count($TO) > 100}
                        <input type="text" id="toEmailCount" class="row-fluid" value="{count($TO)} {vtranslate('LBL_SELECTED_RECIPIENTS',$MODULE)}" readonly>
                        <input type="hidden" id="toEmail" name="toEmail"  class="row-fluid"
						value="{$TO_EMAILS}" data-validation-engine="validate[required, funcCall[Vtiger_To_Email_Validator_Js.invokeValidation]]"
						data-fieldinfo='{$FIELD_INFO}'
						{if !empty($SPECIAL_VALIDATOR)}data-validator='{json_encode($SPECIAL_VALIDATOR)}'{/if}/>
                    {else}
						<input type="hidden" id="toEmailCount" class="row-fluid" value=" {vtranslate('LBL_SELECTED_RECIPIENTS',$MODULE)}" readonly>
						<div id="toEmailViewId">
							<input type="text" id="toEmail" name="toEmail" class="row-fluid autoComplete emailField select2"
							value="{$TO_EMAILS}" data-validation-engine="validate[required, funcCall[Vtiger_To_Email_Validator_Js.invokeValidation]]"
							data-fieldinfo='{$FIELD_INFO}'
							{if !empty($SPECIAL_VALIDATOR)}data-validator='{json_encode($SPECIAL_VALIDATOR)}'{/if}/>
						</div>
                    {/if}

				</span>
			</span>
			</span>
			<span class="span4">
				<span class="row-fluid">
					<span class="span10">
						<div class="input-prepend">
							<span class="pull-right">
								<span class="add-on cursorPointer" name="clearToEmailField"><i class="icon-remove-sign" title="{vtranslate('LBL_CLEAR', $MODULE)}"></i></span>
								<select class="chzn-select emailModulesList" style="width:150px;">
									<optgroup>
										{foreach item=MODULE_NAME from=$RELATED_MODULES}
											<option value="{$MODULE_NAME}" {if $MODULE_NAME eq $FIELD_MODULE} selected {/if}>{vtranslate($MODULE_NAME,$MODULE_NAME)}</option>
										{/foreach}
									</optgroup>
								</select>
							</span>
						</div>
					</span>
					<span class="input-append span2 margin0px">
							<span class="add-on selectEmail cursorPointer"><i class="icon-search" title="{vtranslate('LBL_SELECT', $MODULE)}"></i></span>
					</span>
				</span>
			</span>
		</div>
		<div class="{if empty($CC)}hide {/if} padding10 row-fluid" id="ccContainer">
			<div class="span8">
				<div class="row-fluid">
					<div class="span2">{vtranslate('LBL_CC',$MODULE)}</div>
					<input class="span9 row-fluid emailField select2" data-validation-engine="validate[funcCall[Vtiger_To_Email_Validator_Js.invokeValidation]]" type="text" name="cc" value="{if !empty($CC)}{$CC}{/if}"/>
				</div>
			</div>
			<div class="span4"></div>
		</div>
		<div class="row-fluid {if empty($BCC)}hide {/if} padding10" id="bccContainer">
			<span class="span8">
				<span class="row-fluid">
					<span class="span2">{vtranslate('LBL_BCC',$MODULE)}</span>
					<input class="span9 row-fluid emailField select2" data-validation-engine="validate[funcCall[Vtiger_To_Email_Validator_Js.invokeValidation]]" type="text" name="bcc" value="{if !empty($BCC)}{$BCC}{/if}"/>
				</span>
			</span>
			<span class="span4"></span>
		</div>
		<div class="row-fluid {if (!empty($CC)) and (!empty($BCC))} hide {/if} padding10">
			<span class="span8">
				<span class="row-fluid">
					<span class="span2">&nbsp;</span>
					<span class="span10">
						<a class="cursorPointer {if (!empty($CC))}hide{/if}" id="ccLink">{vtranslate('LBL_ADD_CC', $MODULE)}</a>&nbsp;&nbsp;
						<a class="cursorPointer {if (!empty($BCC))}hide{/if}" id="bccLink">{vtranslate('LBL_ADD_BCC', $MODULE)}</a>
					</span>
				</span>
			</span>
			<span class="span4"></span>
		</div>
		<div class="row-fluid padding10">
			<span class="span8">
				<span class="row-fluid">
					<span class="span2">{vtranslate('LBL_SUBJECT',$MODULE)}<span class="redColor">*</span></span>
						<span class="span9">
							<input data-validation-engine='validate[required]' class="row-fluid" type="text" name="subject" value="{$SUBJECT|escape}" id="subject" spellcheck="true"/>
						</span>
					</span>
				</span>
			<span class="span4"></span>
		</div>
		<div class="row-fluid padding10">
			<span class="span8">
				<span class="row-fluid">
					<span class="span2">{vtranslate('LBL_ATTACHMENT',$MODULE)}</span>
					<span class="span10">
						<input type="file" multiple="multiple" name="file[]"  id="multiFile" class="multi" maxlength="10"/>&nbsp;
						<button type="button" class="btn btn-small" id="browseCrm" data-url="{$DOCUMENTS_URL}" title="{vtranslate('LBL_BROWSE_CRM',$MODULE)}">{vtranslate('LBL_BROWSE_CRM',$MODULE)}</button>
						<div id="attachments" class="row-fluid">
							{foreach item=ATTACHMENT from=$ATTACHMENTS}
								{if ('docid'|array_key_exists:$ATTACHMENT)}
									{assign var=DOCUMENT_ID value=$ATTACHMENT['docid']}
									{assign var=FILE_TYPE value="document"}
								{else}
									{assign var=FILE_TYPE value="file"}
								{/if}
								<div class="MultiFile-label customAttachment" data-file-id="{$ATTACHMENT['fileid']}" data-file-type="{$FILE_TYPE}" data-file-size="{$ATTACHMENT['size']}" {if $FILE_TYPE eq "document"} data-document-id="{$DOCUMENT_ID}"{/if}>
									{if $ATTACHMENT['nondeletable'] neq true}
										<a name="removeAttachment" class="cursorPointer">x </a>
									{/if}
									<span>{$ATTACHMENT['attachment']}</span>
								</div>
							{/foreach}
						</div>
					</span>
				</span>
			</span>
			<span class="span4"></span>
		</div>
		{if $MODULE_IS_ACTIVE}
		<div class="row-fluid padding10">
			<span class="span8">
				<span class="row-fluid">
					<span class="span2">{vtranslate('LBL_SELECT_SUBSTITUTE_TYPE',$MODULE)}</span>
					<span class="span10">
						<input type="hidden" id="moduleFields" name="moduleFields" data-value='{json_encode($TEMPLATEFIELDS)|escape}' />
						<span class="conditionRow">
							<select class="chzn-select" id="modulename" name="modulename" >
								<option value="none">{vtranslate('LBL_SELECT_MODULE',$MODULE)}</option>
								{foreach key=MODULENAME item=FILEDS from=$TEMPLATEFIELDS}
									{if $MODULENAME eq '0'}
										<option value="generalFields">{vtranslate('LBL_GENERAL_FIELDS', $MODULE)}</option>
									{else}
										<option value="{$MODULENAME}">{vtranslate($MODULENAME, $MODULENAME)}</option>
									{/if}
								{/foreach}
							</select>
						</span>&nbsp;&nbsp;
						<span class="" >
							<select class="chzn-select " id="templateFields" name="templateFields">
								<option value="">{vtranslate('LBL_NONE',$MODULE)}</option>
							</select>
						</span>				
					</span>
				</span>
			</span>
		</div>
		{/if}
		<div class="paddingTop20 row-fluid boxSizingBorderBox">
			<div class="span9">
				<div class="btn-toolbar">
                <span class="btn-group marginLeftZero" style="display:inline">
                    <button class="btn btn-success" id="sendEmail" type="submit" title="{vtranslate('LBL_SEND',$MODULE)}"><strong>{vtranslate('LBL_SEND',$MODULE)}</strong></button>&nbsp;&nbsp;
                    <button type="submit" class="btn" style="" id="saveDraft" title="{vtranslate('LBL_SAVE_AS_DRAFT',$MODULE)}"><strong>{vtranslate('LBL_SAVE_AS_DRAFT',$MODULE)}</strong></button>
                    {if !empty($PARENT_EMAIL_ID)}
                        <button type="button" class="btn" id="gotoPreview" title="{vtranslate('LBL_GO_TO_PREVIEW',$MODULE)}" style="margin-left: 5px;"><strong>{vtranslate('LBL_GO_TO_PREVIEW',$MODULE)}</strong></button>
                    {/if}
                    <button type="button" class="btn" id="previewEmail" data-url="{$EMAIL_TEMPLATE_URL}"  style="margin-left: 5px;" title="{vtranslate('LBL_EMAIL_PREVIEW',$MODULE)}"><strong>{vtranslate('LBL_EMAIL_PREVIEW',$MODULE)}</strong></button>
                    <label style="display:inline;margin:0 12px;line-height:25px"><input type="checkbox" name="nosignature" style="vertical-align:text-top"> {vtranslate('LBL_NO_SIGNATURE',$MODULE)}</label>
                    {if $MODULE_IS_ACTIVE}
                        <button type="button" class="btn" style="float:none" id="selectEmailTemplate" data-url="{$EMAIL_TEMPLATE_URL}" title="{vtranslate('LBL_SELECT_EMAIL_TEMPLATE',$MODULE)}"><strong>{vtranslate('LBL_SELECT_EMAIL_TEMPLATE',$MODULE)}</strong></button>
                    {/if}
                </span>
				<span name="progressIndicator" style="height:30px;">&nbsp;</span>
				</div>
			</div>
		</div>
		{if $RELATED_LOAD eq true}
			<input type="hidden" name="related_load" value={$RELATED_LOAD} />
		{/if}
		<textarea id="description" name="description">{$DESCRIPTION}</textarea>
		<input type="hidden" name="attachments" value='{json_encode($ATTACHMENTS)}' />
	</form>
</div>

{include file='JSResources.tpl'|@vtemplate_path}
{/strip}
