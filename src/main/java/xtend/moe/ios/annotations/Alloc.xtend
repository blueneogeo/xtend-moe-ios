package xtend.moe.ios.annotations

import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility
import org.moe.natj.general.Pointer
import org.moe.natj.objc.ann.Selector

/**
 * Generates the NSObject alloc and pointer methods for this class:
 * 
 * ```xtend
 * @Selector("alloc") def static native MapViewController alloc()
 * 
 * protected new(Pointer peer) { super(peer) }
 * ```
 */
@Active(AllocProcessor)
annotation Alloc {
	
}

class AllocProcessor extends AbstractClassProcessor {
	
	override doTransform(MutableClassDeclaration cls, extension TransformationContext context) {
		cls.addMethod('alloc') [
			static = true
			native = true
			addAnnotation ( Selector.newAnnotationReference [ setStringValue('value', 'alloc') ] )
			returnType = cls.newTypeReference
		]
		
		cls.addConstructor [
			visibility = Visibility.PROTECTED
			addParameter('peer', Pointer.newTypeReference)
			body = '''super(peer);'''
		]
	}
	
}
