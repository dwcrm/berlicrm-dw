<?php
/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/

class Settings_Vtiger_CompanyDetails_Model extends Settings_Vtiger_Module_Model {

	STATIC $logoSupportedFormats = array('jpeg', 'jpg', 'png', 'gif', 'pjpeg', 'x-png');

	var $baseTable = 'vtiger_organizationdetails';
	var $baseIndex = 'organization_id';
	var $listFields = array('organizationname');
	var $nameFields = array('organizationname');
	var $logoPath = 'test/logo/';

	var $fields = array(
			'organizationname' => 'text',
			'logoname' => 'text',
			'logo' => 'file',
			'address' => 'textarea',
			'city' => 'text',
			'state' => 'text',
			'code'  => 'text',
			'country' => 'text',
			'phone' => 'text',
			'fax' => 'text',
			'website' => 'text', 
            'vatid' => 'text',
            'tax_id' => 'text',
            'management' => 'text',
            'irsname' => 'text',
            'bankname' => 'text',
            'bankstreet' => 'text',
            'bankcity' => 'text',
            'bankzip' => 'text',
            'bankcountry' => 'text',
            'bankaccount' => 'text',
            'bankrouting' => 'text',
            'bankswift' => 'text',
            'bankiban' => 'text',
	);

	/**
	 * Function to get Edit view Url
	 * @return <String> Url
	 */
	public function getEditViewUrl() {
		return 'index.php?module=Vtiger&parent=Settings&view=CompanyDetailsEdit';
	}
	
	/**
	 * Function to get CompanyDetails Menu item
	 * @return menu item Model
	 */
	public function getMenuItem() {
		$menuItem = Settings_Vtiger_MenuItem_Model::getInstance('LBL_COMPANY_DETAILS');
		return $menuItem;
	}
	
	/**
	 * Function to get Index view Url
	 * @return <String> URL
	 */
	public function getIndexViewUrl() {
		$menuItem = $this->getMenuItem();
		return 'index.php?module=Vtiger&parent=Settings&view=CompanyDetails&block='.$menuItem->get('blockid').'&fieldid='.$menuItem->get('fieldid');
	}

	/**
	 * Function to get fields
	 * @return <Array>
	 */
	public function getFields() {
		return $this->fields;
	}

	/**
	 * Function to get Logo path to display
	 * @return <String> path
	 */
	public function getLogoPath() {
		$logoPath = $this->logoPath;
		$handler = @opendir($logoPath);
		$logoName = $this->get('logoname');
		if ($logoName && $handler) {
			while ($file = readdir($handler)) {
				if($logoName === $file && in_array(str_replace('.', '', strtolower(substr($file, -4))), self::$logoSupportedFormats) && $file != "." && $file!= "..") {
					closedir($handler);
					return $logoPath.$logoName;
				}
			}
		}
		return '';
	}

	/**
	 * Function to save the logoinfo
	 */
	public function saveLogo($binFileName) {
		if ($binFileName) {
			$uploadDir = vglobal('root_directory'). '/' .$this->logoPath;
			$logoName = $uploadDir.$binFileName;
			move_uploaded_file($_FILES["logo"]["tmp_name"], $logoName);
			copy($logoName, $uploadDir.'application.ico');
		}
	}

	/**
	 * Function to save the Company details
	 */
	public function save() {
		$db = PearDatabase::getInstance();
		$id = $this->get('id');
		$fieldsList = $this->getFields();
		unset($fieldsList['logo']);
		$tableName = $this->baseTable;

		if ($id || $id == 0) {
			$params = array();

			$query = "UPDATE $tableName SET ";
			foreach ($fieldsList as $fieldName => $fieldType) {
				$query .= " $fieldName = ?, ";
				array_push($params, $this->get($fieldName));
			}
			$query .= " logo = NULL WHERE organization_id = ?";

			array_push($params, $id);
		} else {
			$params = $this->getData();

			$query = "INSERT INTO $tableName (";
			foreach ($fieldsList as $fieldName => $fieldType) {
				$query .= " $fieldName,";
			}
			$query .= " organization_id) VALUES (". generateQuestionMarks($params). ", ?)";

			array_push($params, $db->getUniqueID($this->baseTable));
		}
		$db->pquery($query, $params);
	}

	/**
	 * Function to get the instance of Company details module model
	 * @return <Settings_Vtiger_CompanyDetais_Model> $moduleModel
	 */
	public static function getInstance($name=false) {
		$moduleModel = new self();
		$db = PearDatabase::getInstance();

		$result = $db->pquery("SELECT * FROM vtiger_organizationdetails", array());
		if ($db->num_rows($result) == 1) {
			$moduleModel->setData($db->query_result_rowdata($result));
			$moduleModel->set('id', $moduleModel->get('organization_id'));
		}

		$moduleModel->getFields();
		return $moduleModel;
	}
        
        /** 
        * @var array(string => string) 
        */ 
       private static $settings = array();  

       /** 
        * @param string $fieldname 
        * @return string 
        */ 
       public static function getSetting($fieldname) { 
            global $adb; 
            if (!self::$settings) { 
                    self::$settings = $adb->database->GetRow("SELECT * FROM vtiger_organizationdetails"); 
            } 
            return self::$settings[$fieldname]; 
       } 
	   
	/**
	 * crm-now: added for Login images display
	 * Function to get Logo path to display all 3 login logos
	 * @return <String> path
	 */
	public function getLoginLogoPath($no) {
		$logoPath = $this->logoPath;
		$handler = @opendir($logoPath);
		$logoName = 'start_main.jpg';
		if ($no==2) {
			$logoName = 'start_main_kundenportal.jpg';
		}
		if ($no==3) {
			$logoName = 'start_main_kundenportal_en.jpg';
		}
		if ($logoName && $handler) {
			while ($file = readdir($handler)) {
				if($logoName === $file && in_array(str_replace('.', '', strtolower(substr($file, -4))), self::$logoSupportedFormats) && $file != "." && $file!= "..") {
					closedir($handler);
					return $logoPath.$logoName;
				}
			}
		}
		return '';
	}
	/**
	 * crm-now: added for Login images save
	 * Function to save the Login logoinfos
	 */
	public function saveLoginLogo($file,$key) {
		$uploadDir = vglobal('root_directory'). '/' .$this->logoPath;
		$logoName = $uploadDir.$file["name"];
		move_uploaded_file($file["tmp_name"], $logoName);
		if ($key=='p1') {
			copy($logoName, $uploadDir.'start_main.jpg');
		}
		elseif ($key=='p2') {
			copy($logoName, $uploadDir.'start_main_kundenportal.jpg');
		}
        elseif ($key=='p4') {
			copy($logoName, $uploadDir.'crmnow_logo_header.png');
		}
		else {
			copy($logoName, $uploadDir.'start_main_kundenportal_en.jpg');
		}
	}
	   
}